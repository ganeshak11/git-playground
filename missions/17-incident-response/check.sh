# shellcheck shell=bash
# Mission 17 check — verifies that:
# 1. Broken WIP code was reverted on main and pushed to origin/main.
# 2. Experimental code was preserved on branch feature/payment-gateway.
# 3. INCIDENT.md exists with required post-mortem analysis (cause, fix, prevention).

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean (ignoring INCIDENT.md whether tracked or untracked)
local dirty
dirty="$(git status --porcelain 2>/dev/null | grep -v "INCIDENT\.md" || true)"
if [[ -n "$dirty" ]]; then
    fail "Working tree has uncommitted modifications. Run 'git status' to inspect."
fi

# 2. Must be on main branch
assert_on_branch "main"

# 3. Broken gateway.py must not exist on main
if [[ -f "gateway.py" ]]; then
    fail "gateway.py still exists on main. Did you revert the accidental commit on main?"
fi

# 4. Top commit on main must be a revert commit
assert_msg "HEAD" "Revert"

# 5. Local main must be pushed to origin/main
local local_head remote_head
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse main 2>/dev/null)"
if [[ "$local_head" != "$remote_head" ]]; then
    fail "Your revert commit on main has not been pushed to origin/main. Run 'git push origin main'."
fi

# 6. Branch feature/payment-gateway must exist and contain gateway.py
assert_branch_exists "feature/payment-gateway"
if ! git ls-tree -r feature/payment-gateway | grep -q "gateway\.py"; then
    fail "Branch 'feature/payment-gateway' does not contain gateway.py. Did you branch from the WIP commit before reverting?"
fi

# 7. INCIDENT.md must exist and contain key post-mortem elements
assert_file_exists "INCIDENT.md"

if ! grep -qiE "(direct push|pushed to main|accidental push|without a branch)" INCIDENT.md; then
    fail "INCIDENT.md must explain what happened (accidental direct push to main)."
fi

if ! grep -qiE "(revert)" INCIDENT.md; then
    fail "INCIDENT.md must explain the remediation (using git revert on main)."
fi

if ! grep -qiE "(branch protection|protection rule|pull request|\bpr\b|code review)" INCIDENT.md; then
    fail "INCIDENT.md must explain prevention (e.g. branch protection rules or requiring pull requests)."
fi

pass "Incident successfully resolved! Main restored, work rescued to feature branch, and incident report filed."
