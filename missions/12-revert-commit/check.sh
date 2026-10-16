# shellcheck shell=bash
# Mission 12 check — verifies that the buggy middle commit was reverted cleanly,
# the subsequent features remain intact, history was preserved (not rewritten),
# and the revert commit was pushed to origin/main.

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on main branch
assert_clean
assert_on_branch "main"

# 2. Buggy surcharge must be gone from billing.py
if grep -q "calculate_surcharge" billing.py 2>/dev/null; then
    fail "billing.py still contains the buggy 'calculate_surcharge' function."
fi

# 3. Subsequent features (receipt.py, README support section) must still exist intact
assert_file_exists "receipt.py"
assert_file_contains "receipt.py" "generate_receipt"
assert_file_contains "README.md" "support@example.com"

# 4. History must not have been rewritten with reset; the bad commit must still be in history
local bad_commit
bad_commit="$(play_recall "bad_commit_hash")"
if [[ -n "$bad_commit" ]]; then
    assert_reachable "$bad_commit" "HEAD"
fi

# 5. Must have created a new revert commit on top
assert_commit_count "HEAD" 5
assert_msg "HEAD" "Revert"

# 6. Must be pushed to origin/main
local local_head remote_head
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse main 2>/dev/null)"
if [[ "$local_head" != "$remote_head" ]]; then
    fail "Your local revert commit has not been pushed to origin/main. Run 'git push origin main'."
fi

pass "Middle commit successfully reverted and pushed to origin/main without rewriting history!"
