# shellcheck shell=bash
# Mission 7 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. main has exactly 2 commits (initial setup + cherry-picked bugfix).
# 3. db.py contains the SQL injection fix.
# 4. ui.py does NOT contain the experimental UI redesign or 3D canvas code.
# 5. Latest commit message matches the security fix.
# 6. The experimental branch still exists intact.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo"

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. main has exactly 2 commits
assert_commit_count "main" 2

# 3. db.py has the SQL injection fix
assert_file_contains "${SANDBOX}/repo/db.py" "sanitize inputs to prevent SQL injection"

# 4. ui.py must remain the standard UI
if grep -q "modern" "${SANDBOX}/repo/ui.py" || grep -q "ThreeJS" "${SANDBOX}/repo/ui.py"; then
    fail "Experimental UI changes were merged into main! Only cherry-pick the db.py bugfix commit."
fi

# 5. Latest commit message mentions SQL injection
assert_msg "HEAD" "Fix critical SQL injection"

# 6. Experimental branch intact
assert_branch_exists "experiment/next-gen-ui"

pass "Bugfix cleanly cherry-picked onto main without merging experimental code!"
