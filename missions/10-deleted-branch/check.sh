# shellcheck shell=bash
# Mission 10 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. Branch feature/search-indexing exists.
# 3. Branch points to the expected commit from before deletion.
# 4. Files on feature/search-indexing are fully intact.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo"

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. feature/search-indexing branch must exist
assert_branch_exists "feature/search-indexing"

# 3. Must match the exact commit from before deletion
expected_commit="$(play_recall "search_commit")"
actual_commit="$(git rev-parse feature/search-indexing 2>/dev/null)"
assert_refs_equal "$actual_commit" "feature/search-indexing" "$expected_commit" "expected search commit"

# 4. Files must be intact
if ! git show feature/search-indexing:tokenizer.py >/dev/null 2>&1; then
    fail "'tokenizer.py' is missing from feature/search-indexing!"
fi
if ! git show feature/search-indexing:search.py 2>/dev/null | grep -q "build_index"; then
    fail "'search.py' on feature/search-indexing is missing the search algorithm!"
fi

pass "Branch successfully resurrected from the reflog with all code and history intact! You've mastered git reflog."
