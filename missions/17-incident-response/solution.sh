# shellcheck shell=bash
# Mission 17 reference solution:
# 1. Rescues WIP code to feature/payment-gateway
# 2. Reverts accidental commit on main and pushes to origin/main
# 3. Writes INCIDENT.md post-mortem report

cd "${SANDBOX}/repo" || exit 1

# 1. Create feature branch to preserve experimental code before reverting main
git branch feature/payment-gateway >/dev/null 2>&1

# 2. Revert the accidental commit on main
git switch main >/dev/null 2>&1
git revert --no-edit HEAD >/dev/null 2>&1
git push origin main >/dev/null 2>&1

# 3. Write INCIDENT.md
cat << 'EOF' > INCIDENT.md
# Incident Post-Mortem: Accidental Direct Push to Main

## 1. Summary & What Happened
An engineer accidentally made a direct push of broken, incomplete experimental code to the `main` branch without a branch or pull request, breaking production builds.

## 2. Root Cause
The developer committed directly on their local `main` branch instead of a feature branch and ran `git push origin main` without branch protection enabled.

## 3. Remediation
1. Created branch `feature/payment-gateway` from the commit to ensure the developer's work was preserved.
2. Executed `git revert` on `main` to safely undo the broken changes.
3. Pushed the revert commit to `origin/main` to restore pipeline health.

## 4. Prevention
1. Enable GitHub branch protection rules on `main` requiring pull requests and mandatory code review approvals before merging.
2. Require all CI status checks to pass before any code can merge to `main`.
EOF
