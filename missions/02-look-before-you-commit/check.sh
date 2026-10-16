# shellcheck shell=bash
# Mission 2 check — verifies:
# 1. Working tree is clean.
# 2. .env and debug.log exist on disk but are untracked and ignored.
# 3. .gitignore exists, is committed, and ignores .env and debug.log.
# 4. server.js has /health and has NO temporary debug code.
# 5. config.js has TIMEOUT.
# 6. A clean commit exists on main.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean & on main branch
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. .env must exist on disk, but NOT be tracked in Git
assert_file_exists "${SANDBOX}/repo/.env"
if git ls-files --error-unmatch .env >/dev/null 2>&1; then
    fail "'.env' was committed or tracked in Git! Secrets should never be committed."
fi

# 3. debug.log must exist on disk, but NOT be tracked in Git
assert_file_exists "${SANDBOX}/repo/debug.log"
if git ls-files --error-unmatch debug.log >/dev/null 2>&1; then
    fail "'debug.log' was committed or tracked in Git! Log files should be ignored."
fi

# 4. .gitignore must exist and be committed
assert_file_exists "${SANDBOX}/repo/.gitignore"
if ! git ls-files --error-unmatch .gitignore >/dev/null 2>&1; then
    fail "'.gitignore' was created but not committed. Stage and commit it with: git add .gitignore"
fi

# 5. .gitignore must actually match .env and debug.log
if ! git check-ignore -q .env; then
    fail "'.env' is not ignored by your .gitignore rules."
fi
if ! git check-ignore -q debug.log; then
    fail "'debug.log' is not ignored by your .gitignore rules."
fi

# 6. config.js must contain TIMEOUT
assert_file_contains "${SANDBOX}/repo/config.js" "TIMEOUT"

# 7. server.js must contain /health and NOT contain DEBUG
assert_file_contains "${SANDBOX}/repo/server.js" "/health"
if grep -qi "DEBUG" "${SANDBOX}/repo/server.js"; then
    fail "'server.js' still contains the temporary DEBUG log line! Remove it before committing."
fi

# 8. Check that a new commit was created on main
main_count="$(git rev-list --count main 2>/dev/null || echo 0)"
if [[ "$main_count" -lt 2 ]]; then
    fail "No new commit found on main. Stage your clean changes and commit."
fi

# 9. Verify HEAD does not track secrets or logs
if git log -1 --name-only | grep -E '^\.env$|^debug\.log$' >/dev/null 2>&1; then
    fail "The latest commit includes .env or debug.log! Secrets/logs must not enter Git history."
fi

pass "Outstanding! Secrets and logs are safely ignored, debug prints removed, and clean code committed."
