# shellcheck shell=bash
# Mission 18 reference solution:
# 1. Update local main with teammate Alex's changes
# 2. Rebase feature/notifications onto main
# 3. Resolve merge conflict in config.json
# 4. Continue rebase
# 5. Push feature branch using --force-with-lease
# 6. Fast-forward merge feature into main and push main

cd "${SANDBOX}/repo" || exit 1

# 1. Update main from remote
git switch main >/dev/null 2>&1
git pull origin main >/dev/null 2>&1

# 2. Switch to feature branch and rebase onto updated main
git switch feature/notifications >/dev/null 2>&1
git rebase main >/dev/null 2>&1 || true

# 3. Resolve the config.json conflict by combining both features
cat << 'EOF' > config.json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management",
    "audit_logging",
    "notifications"
  ]
}
EOF

git add config.json
GIT_EDITOR="true" git rebase --continue >/dev/null 2>&1

# 4. Push updated feature branch with lease
git push --force-with-lease origin feature/notifications >/dev/null 2>&1

# 5. Fast-forward merge into main and push
git switch main >/dev/null 2>&1
git merge --ff-only feature/notifications >/dev/null 2>&1
git push origin main >/dev/null 2>&1
