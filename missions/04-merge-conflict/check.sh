# shellcheck shell=bash
# Mission 4 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. No active merge in progress (.git/MERGE_HEAD does not exist).
# 3. No conflict markers (<<<<<<<, =======, >>>>>>>) remain in app.py.
# 4. app.py contains the agreed resolution (MAX_ITEMS_PER_PAGE = 100).
# 5. Local main matches remote main (pushed to origin).

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean & on main branch
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. No merge in progress
if [[ -f .git/MERGE_HEAD ]]; then
    fail "A merge is still in progress! Finish resolving and run 'git commit'."
fi

# 3. No conflict markers left
if grep -E '<<<<<<<|=======|>>>>>>>' app.py >/dev/null 2>&1; then
    fail "Conflict markers (<<<<<<<, =======, >>>>>>>) are still present in app.py! Remove all marker lines."
fi

# 4. Correct resolution applied
assert_file_contains "${SANDBOX}/repo/app.py" "MAX_ITEMS_PER_PAGE = 100"

# 5. Verify local main matches remote main (push succeeded)
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse refs/heads/main 2>/dev/null)" \
    || fail "Remote has no main branch."

if [[ "$local_head" != "$remote_head" ]]; then
    if git merge-base --is-ancestor "$local_head" "$remote_head"; then
        fail "Your branch is behind origin/main. Run: git pull origin main"
    elif git merge-base --is-ancestor "$remote_head" "$local_head"; then
        fail "You resolved the conflict locally, but have not pushed yet. Run: git push origin main"
    else
        fail "Local main and remote main have diverged. Pull remote changes with 'git pull origin main', resolve conflicts, and push."
    fi
fi

pass "Conflict cleanly resolved! All markers removed, pagination limit updated, and merged history pushed."
