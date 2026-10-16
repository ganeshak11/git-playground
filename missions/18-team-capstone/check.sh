# shellcheck shell=bash
# Mission 18 check — verifies completion of the Capstone Sprint:
# 1. feature/notifications was rebased onto updated main and conflict in config.json resolved.
# 2. Both notifications and audit features are present and functioning.
# 3. Remote feature branch was updated with --force-with-lease.
# 4. feature was merged to main and pushed to origin/main with a clean linear history.

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on main branch
assert_clean
assert_on_branch "main"

# 2. Rebase must be finished
if [[ -d ".git/rebase-merge" || -d ".git/rebase-apply" ]]; then
    fail "A rebase is still in progress. Finish it with 'git rebase --continue' or abort with 'git rebase --abort'."
fi

# 3. Both files must exist on main
assert_file_exists "notifications.py"
assert_file_contains "notifications.py" "send_notification"
assert_file_exists "audit.py"
assert_file_contains "audit.py" "log_audit"

# 4. config.json must contain both features and no conflict markers
assert_file_contains "config.json" "notifications"
assert_file_contains "config.json" "audit_logging"

if grep -qE "<<<<<<|======|>>>>>>" config.json 2>/dev/null; then
    fail "config.json still contains merge conflict markers! Resolve them and commit."
fi

# 5. Clean linear history (no merge commits on main)
if [[ -n "$(git log --merges origin/main -1 --oneline 2>/dev/null)" ]]; then
    fail "Found a merge commit on main. The sprint requires a clean linear history via rebase and fast-forward merge."
fi

# 6. Local main must be pushed to origin/main
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse main 2>/dev/null)"
if [[ "$local_head" != "$remote_head" ]]; then
    fail "Your local main is not pushed to origin/main. Run 'git push origin main'."
fi

# 7. Local feature/notifications must be pushed to origin/feature/notifications
local_feat="$(git rev-parse feature/notifications 2>/dev/null)"
remote_feat="$(git -C "${SANDBOX}/remote.git" rev-parse feature/notifications 2>/dev/null)"
if [[ "$local_feat" != "$remote_feat" ]]; then
    fail "Your rebased feature branch is not pushed to origin. Did you run 'git push --force-with-lease'?"
fi

pass "CAPSTONE COMPLETE! Clean linear sprint workflow executed with flying colors!"
