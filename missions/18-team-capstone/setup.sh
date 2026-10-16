# shellcheck shell=bash
# Mission 18 setup — The Capstone Sprint
# Simulates a real team workflow where:
# 1. Base project is set up on main.
# 2. Learner is on feature/notifications, has committed and pushed to origin.
# 3. Teammate Alex moved origin/main forward with audit logging and a conflicting config.json change.
# 4. The learner must fetch/pull, rebase onto main, resolve the conflict in config.json,
#    push --force-with-lease to their feature branch, fast-forward merge into main, and push main.

# 1. Create bare remote
make_bare_remote "remote.git"

# 2. Clone into working repository
git clone "${SANDBOX}/remote.git" "${SANDBOX}/repo" >/dev/null 2>&1

(
    cd "${SANDBOX}/repo"
    git config user.name "You"
    git config user.email "you@example.com"
    git config core.autocrlf false
    git config pull.rebase false

    # Base commit on main
    cat << 'EOF' > README.md
# Task Tracker
Collaborative team task tracking application.
EOF

    cat << 'EOF' > app.py
def main():
    print("Task Tracker v1.0 running...")

if __name__ == "__main__":
    main()
EOF

    cat << 'EOF' > config.json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management"
  ]
}
EOF

    commit_as "LeadDev" "lead@example.com" "Initial project setup"
    git push -u origin main >/dev/null 2>&1

    # Feature branch by learner
    git switch -c feature/notifications >/dev/null 2>&1

    cat << 'EOF' > notifications.py
def send_notification(user, message):
    return f"Notification to {user}: {message}"
EOF

    cat << 'EOF' > config.json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management",
    "notifications"
  ]
}
EOF

    commit_as "You" "you@example.com" "Add notifications feature and config"
    git push -u origin feature/notifications >/dev/null 2>&1
)

# 3. Teammate Alex works and pushes to origin/main
tmp_alex="${SANDBOX}/.alex-tmp"
git clone "${SANDBOX}/remote.git" "$tmp_alex" >/dev/null 2>&1
(
    cd "$tmp_alex"
    git config user.name "Alex"
    git config user.email "alex@example.com"
    git config core.autocrlf false

    cat << 'EOF' > audit.py
def log_audit(action, user):
    return f"AUDIT: {action} by {user}"
EOF

    cat << 'EOF' > config.json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management",
    "audit_logging"
  ]
}
EOF

    commit_as "Alex" "alex@example.com" "Add audit logging and config"
    git push origin main >/dev/null 2>&1
)
rm -rf "$tmp_alex"

say "Repository ready at repo/ on branch 'feature/notifications'."
say "While you were building notifications, teammate Alex pushed audit logging to origin/main."
say "Your config.json will conflict during rebase!"
say "Complete the Capstone Sprint: update main, rebase & resolve, force-push with lease, and merge to main!"
