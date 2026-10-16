# shellcheck shell=bash
# lib/repo.sh — git repo scaffolding for mission setup
#
# All functions expect $SANDBOX to be set to the current mission's sandbox dir.
# Output is captured and only shown on failure — no silent swallowing.

# Create a standard git repo at $SANDBOX/$1 with local-only config.
# Never touches global config.
make_repo() {
    local dir="${SANDBOX}/${1}"
    mkdir -p "$dir"
    local output
    output="$(git init --initial-branch=main "$dir" 2>&1)" \
        || { echo "$output" >&2; fail "Failed to create repo at $dir"; }
    # Local config only
    git -C "$dir" config user.name "You"
    git -C "$dir" config user.email "you@example.com"
    git -C "$dir" config core.autocrlf false
    _set_editor "$dir"
}

# Create a bare repo at $SANDBOX/$1 (what GitHub actually is).
make_bare_remote() {
    local dir="${SANDBOX}/${1}"
    mkdir -p "$dir"
    local output
    output="$(git init --bare --initial-branch=main "$dir" 2>&1)" \
        || { echo "$output" >&2; fail "Failed to create bare repo at $dir"; }
}

# Create a deterministic commit.
# Usage: commit_as NAME EMAIL MSG [FILES...]
#
# Timestamp is derived from the current commit count on HEAD, so each commit
# in a setup gets a unique time even when called from subshells (the old
# global counter approach broke because subshells can't increment parent vars).
# Uses @epoch format which git accepts directly. Supports >59 commits
# (unlike the minutes:seconds approach).
commit_as() {
    local name="$1" email="$2" msg="$3"
    shift 3

    # Base: 2024-01-15T10:00:00 UTC = 1705312800
    local count
    count="$(git rev-list --count HEAD 2>/dev/null || echo 0)"
    local ts="@$((1705312800 + count))"

    export GIT_AUTHOR_DATE="$ts"
    export GIT_COMMITTER_DATE="$ts"
    export GIT_AUTHOR_NAME="$name"
    export GIT_AUTHOR_EMAIL="$email"
    export GIT_COMMITTER_NAME="$name"
    export GIT_COMMITTER_EMAIL="$email"

    if [[ $# -gt 0 ]]; then
        git add "$@"
    else
        git add -A
    fi

    local output
    output="$(git commit -m "$msg" 2>&1)" \
        || { echo "$output" >&2; fail "Failed to commit: $msg"; }

    unset GIT_AUTHOR_DATE GIT_COMMITTER_DATE
    unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
    unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL
}

# Simulate a teammate pushing to a bare remote.
# Usage: teammate_push REMOTE_PATH NAME EMAIL MSG FILE CONTENT
teammate_push() {
    local remote_path="$1" name="$2" email="$3" msg="$4" file="$5" content="$6"
    local tmp_clone="${SANDBOX}/.teammate-tmp"

    rm -rf "$tmp_clone"
    local output
    output="$(git clone "$remote_path" "$tmp_clone" 2>&1)" \
        || { echo "$output" >&2; fail "teammate_push: failed to clone $remote_path"; }

    git -C "$tmp_clone" config user.name "$name"
    git -C "$tmp_clone" config user.email "$email"
    git -C "$tmp_clone" config core.autocrlf false

    echo "$content" > "${tmp_clone}/${file}"
    (
        cd "$tmp_clone" || exit 1
        commit_as "$name" "$email" "$msg" "$file"
    )

    output="$(git -C "$tmp_clone" push 2>&1)" \
        || { echo "$output" >&2; fail "teammate_push: failed to push"; }

    rm -rf "$tmp_clone"
}

# Pick an editor that won't trap a beginner in vim.
_set_editor() {
    local dir="$1"
    if command -v code >/dev/null 2>&1; then
        git -C "$dir" config core.editor "code --wait"
    elif command -v nano >/dev/null 2>&1; then
        git -C "$dir" config core.editor "nano"
    elif [[ "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]]; then
        git -C "$dir" config core.editor "notepad"
    fi
    # Otherwise leave git's default (vi/vim)
}

# Store a value in the mission's .play metadata dir.
play_store() {
    local key="$1" value="$2"
    mkdir -p "${SANDBOX}/.play"
    echo "$value" > "${SANDBOX}/.play/${key}"
}

# Retrieve a stored value.
play_recall() {
    local key="$1"
    cat "${SANDBOX}/.play/${key}" 2>/dev/null || true
}
