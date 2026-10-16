# shellcheck shell=bash
# Mission 3 check — verifies that:
# 1. Working tree is clean and on branch main.
# 2. Alex's changes (notifications.txt) are present.
# 3. Your local changes (user settings in tasks.txt) are present.
# 4. Local main and remote origin/main match (push succeeded).

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean & on main branch
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. Check that Alex's file was integrated
assert_file_exists "${SANDBOX}/repo/notifications.txt"

# 3. Check that your own changes were preserved
assert_file_contains "${SANDBOX}/repo/tasks.txt" "user settings"

# 4. Verify local main matches remote main
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse refs/heads/main 2>/dev/null)" \
    || fail "Remote has no main branch."

if [[ "$local_head" != "$remote_head" ]]; then
    if git merge-base --is-ancestor "$local_head" "$remote_head"; then
        fail "Your branch is behind origin/main. Run: git pull origin main"
    elif git merge-base --is-ancestor "$remote_head" "$local_head"; then
        fail "You have integrated remote changes, but have not pushed yet. Run: git push origin main"
    else
        fail "Local main and remote main have diverged. Pull remote changes with 'git pull origin main', then push."
    fi
fi

pass "Both your commits and Alex's commits are unified on remote main. Push successful!"
