# shellcheck shell=bash
# lib/assert.sh — building blocks for check.sh
#
# Each function either passes silently or calls fail() with a diagnostic
# message that points toward the problem without giving the solution.

# Is the working tree clean? (no staged, unstaged, or untracked changes)
assert_clean() {
    local dir="${1:-.}"
    if [[ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]]; then
        fail "Working tree is not clean. Run 'git status' to see what's left."
    fi
}

# Is a commit reachable from a ref?
assert_reachable() {
    local commit="$1" ref="${2:-HEAD}"
    if ! git merge-base --is-ancestor "$commit" "$ref" 2>/dev/null; then
        fail "Commit ${commit:0:8} is not reachable from $ref."
    fi
}

# Does a branch exist?
assert_branch_exists() {
    local branch="$1"
    if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
        fail "Branch '$branch' does not exist."
    fi
}

# Does a branch NOT exist?
assert_no_branch() {
    local branch="$1"
    if git rev-parse --verify "$branch" >/dev/null 2>&1; then
        fail "Branch '$branch' still exists — it should have been deleted."
    fi
}

# Does HEAD point to a specific branch? (not detached)
assert_on_branch() {
    local branch="$1"
    local current
    current="$(git symbolic-ref --short HEAD 2>/dev/null || echo "DETACHED")"
    if [[ "$current" != "$branch" ]]; then
        fail "Expected to be on branch '$branch', but you're on '$current'."
    fi
}

# Does a commit message contain expected text?
assert_msg() {
    local ref="$1" expected="$2"
    local actual
    actual="$(git log -1 --format='%s' "$ref" 2>/dev/null)" \
        || fail "Cannot read commit message at $ref."
    if [[ "$actual" != *"$expected"* ]]; then
        fail "Commit message at $ref should contain '$expected', got '$actual'."
    fi
}

# Does a file exist?
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        fail "Expected file '$(basename "$file")' to exist."
    fi
}

# Does a file contain a string?
assert_file_contains() {
    local file="$1" expected="$2"
    if ! grep -q "$expected" "$file" 2>/dev/null; then
        fail "'$(basename "$file")' should contain '$expected'."
    fi
}

# Is a remote configured?
assert_remote() {
    local name="$1"
    if ! git remote get-url "$name" >/dev/null 2>&1; then
        fail "Remote '$name' is not configured."
    fi
}

# Are there exactly N commits on a ref?
assert_commit_count() {
    local ref="$1" expected="$2"
    local actual
    actual="$(git rev-list --count "$ref" 2>/dev/null)" \
        || fail "Cannot count commits on $ref."
    if [[ "$actual" -ne "$expected" ]]; then
        fail "Expected $expected commit(s) on $ref, found $actual."
    fi
}

# Is a directory a bare git repo?
assert_is_bare() {
    local dir="$1"
    local bare
    bare="$(git -C "$dir" rev-parse --is-bare-repository 2>/dev/null)" \
        || fail "'$(basename "$dir")' is not a git repository."
    if [[ "$bare" != "true" ]]; then
        fail "'$(basename "$dir")' should be a bare repository (created with --bare)."
    fi
}

# Do two refs resolve to the same commit?
assert_refs_equal() {
    local ref1="$1" label1="$2" ref2="$3" label2="$4"
    if [[ "$ref1" != "$ref2" ]]; then
        fail "$label1 (${ref1:0:8}) does not match $label2 (${ref2:0:8})."
    fi
}
