# shellcheck shell=bash
# Mission 9 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. Total commits on main is exactly 2.
# 3. test_auth.py is committed in the latest commit.
# 4. The typo "biometirc" is fixed and "biometric" is in the commit message.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. Exactly 2 commits (no extra "oops" commits created)
assert_commit_count "main" 2

# 3. test_auth.py must be committed in HEAD
if ! git ls-files --error-unmatch test_auth.py >/dev/null 2>&1; then
    fail "'test_auth.py' is still untracked! Stage it and amend with: git add test_auth.py && git commit --amend"
fi
if ! git show HEAD:test_auth.py >/dev/null 2>&1; then
    fail "'test_auth.py' was not folded into the latest commit!"
fi

# 4. Typo must be fixed
latest_msg="$(git log -1 --format='%s')"
if [[ "$latest_msg" == *"biometirc"* ]]; then
    fail "The typo 'biometirc' is still in the commit message! Use 'git commit --amend -m ...' to fix it."
fi
if [[ "$latest_msg" != *"biometric"* ]]; then
    fail "The commit message should contain 'biometric' (correctly spelled)."
fi

pass "Forgotten file folded into commit and message corrected in a single clean commit! You've mastered git commit --amend."
