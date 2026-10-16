# shellcheck shell=bash
# Mission 6 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. Total commit count on main is exactly 2.
# 3. The latest commit is not the sloppy "temp stuff whatever" commit.
# 4. payment.py contains process_stripe_payment and no DRAFT BROKEN.
# 5. settings.py contains DEBUG = False (not True).

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. Total commits must be exactly 2 (initial commit + clean replacement commit)
assert_commit_count "main" 2

# 3. Verify sloppy commit was undone
latest_msg="$(git log -1 --format='%s')"
if [[ "$latest_msg" == *"temp stuff"* ]]; then
    fail "The sloppy commit was not undone! Run 'git reset --soft HEAD~1'."
fi

# 4. Check payment.py has clean feature and no broken draft
assert_file_contains "${SANDBOX}/repo/payment.py" "process_stripe_payment"
if grep -q "DRAFT BROKEN" "${SANDBOX}/repo/payment.py"; then
    fail "'payment.py' still contains the broken draft line! Remove it before committing."
fi

# 5. Check settings.py has production settings
assert_file_contains "${SANDBOX}/repo/settings.py" "DEBUG = False"
if grep -q "DEBUG = True" "${SANDBOX}/repo/settings.py"; then
    fail "'settings.py' still has DEBUG = True! Set it to False."
fi

pass "Sloppy commit undone, changes corrected, and clean commit recorded. You've mastered git reset!"
