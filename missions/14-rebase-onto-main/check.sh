# shellcheck shell=bash
# Mission 14 check — verifies that feature/search-filter was rebased onto main,
# resulting in a linear history with main as an ancestor, without merge commits,
# containing both the teammate changes and feature changes.

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean and on feature branch
assert_clean
assert_on_branch "feature/search-filter"

# 2. Rebase is not in progress
if [[ -d ".git/rebase-merge" || -d ".git/rebase-apply" ]]; then
    fail "Rebase is still in progress. Finish it or run 'git rebase --abort'."
fi

# 3. main must be an ancestor of HEAD
local main_head
main_head="$(git rev-parse main 2>/dev/null)"
assert_reachable "$main_head" "HEAD"

# 4. No merge commits (must be a rebase, not a merge)
if [[ -n "$(git log --merges "${main_head}..HEAD" --oneline 2>/dev/null)" ]]; then
    fail "Found a merge commit on your branch. Use 'git rebase main' instead of 'git merge main' for a linear history."
fi

# 5. Exactly 2 feature commits on top of main
assert_commit_count "${main_head}..HEAD" 2

# 6. Both teammate files and feature files must exist
assert_file_exists "db.py"
assert_file_contains "db.py" "Connected to indexed DB"
assert_file_exists "search.py"
assert_file_contains "search.py" "filter by category"

pass "Feature branch successfully rebased onto moved main with clean linear history!"
