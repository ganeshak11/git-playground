# shellcheck shell=bash
# Mission 5 check — verifies:
# 1. Active branch is feature/discount.
# 2. Hotfix (TAX_RATE = 0.05) is committed on main.
# 3. In-progress work (apply_coupon in shop.py and discount_notes.txt) is restored.
# 4. Stash list is empty (stash was popped, not left behind).

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Must be back on feature/discount branch
assert_on_branch "feature/discount"

# 2. Check that hotfix was committed to main
if ! git show main:shop.py 2>/dev/null | grep -q "TAX_RATE = 0.05"; then
    fail "The 'main' branch does not have the hotfix! Expected TAX_RATE = 0.05 committed on main."
fi

main_count="$(git rev-list --count main 2>/dev/null || echo 0)"
if [[ "$main_count" -lt 2 ]]; then
    fail "Expected a new hotfix commit on 'main', found only $main_count commit(s)."
fi

# 3. Check that in-progress work is restored in the working tree
assert_file_contains "${SANDBOX}/repo/shop.py" "apply_coupon"
assert_file_exists "${SANDBOX}/repo/discount_notes.txt"

# 4. Check that the stash was popped (list is empty)
stash_count="$(git stash list | wc -l)"
if [[ "$stash_count" -ne 0 ]]; then
    fail "Stash list is not empty ($stash_count stashes found). Did you use 'git stash pop' to restore your work?"
fi

pass "Hotfix cleanly committed to main, and in-progress work restored with git stash pop!"
