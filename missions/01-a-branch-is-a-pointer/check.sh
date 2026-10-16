# shellcheck shell=bash
# Mission 1 check — verifies branches point to the expected commits
# and that main moved forward with a new commit.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo"

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. Recall expected commit hashes from setup
commit1="$(play_recall "commit1")"
commit2="$(play_recall "commit2")"
commit3="$(play_recall "commit3")"

# 3. Verify feature-v1 branch
assert_branch_exists "feature-v1"
feature_head="$(git rev-parse feature-v1 2>/dev/null)"
assert_refs_equal "$feature_head" "feature-v1" "$commit2" "commit 2 (Implement task list feature)"

# 4. Verify experimental branch
assert_branch_exists "experimental"
exp_head="$(git rev-parse experimental 2>/dev/null)"
assert_refs_equal "$exp_head" "experimental" "$commit1" "commit 1 (Add basic project files)"

# 5. Verify main has a new commit on top of commit 3
main_count="$(git rev-list --count main 2>/dev/null || echo 0)"
if [[ "$main_count" -lt 4 ]]; then
    fail "Expected a new commit on 'main' (total 4 commits), found $main_count. Edit README.md and commit."
fi

parent_head="$(git rev-parse HEAD~1 2>/dev/null)"
assert_refs_equal "$parent_head" "parent of main" "$commit3" "commit 3"

pass "All branch pointers are exactly where they belong. Branches are just pointers!"
