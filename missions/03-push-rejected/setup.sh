# shellcheck shell=bash
# Mission 3 setup — creates a bare remote and a clone,
# adds a local commit in the clone, and simulates a teammate pushing
# to the remote so that history diverges and a direct push is rejected.

# 1. Create bare remote
make_bare_remote "remote.git"

# 2. Clone into working repository
git clone "${SANDBOX}/remote.git" "${SANDBOX}/repo" >/dev/null 2>&1

(
    cd "${SANDBOX}/repo" || exit 1
    git config user.name "You"
    git config user.email "you@example.com"
    git config core.autocrlf false

    # 3. Shared initial commit
    cat << 'EOF' > README.md
# Task Tracker
Team task tracking application.
EOF

    cat << 'EOF' > tasks.txt
1. Build login page
2. Setup database
EOF

    commit_as "You" "you@example.com" "Shared base commit"
    git push -u origin main >/dev/null 2>&1

    # 4. Local commit (unpushed)
    echo "3. Implement user settings (by You)" >> tasks.txt
    commit_as "You" "you@example.com" "Add user settings task"
)

# 5. Teammate Alex pushes to the remote (different file, so no conflict)
teammate_push "${SANDBOX}/remote.git" "Alex" "alex@example.com" \
    "Add notifications task" "notifications.txt" "Task notifications module enabled."

say "Repository ready at repo/."
say "Your local branch is ahead, but teammate Alex already pushed to origin/main."
say "Try running 'git push origin main' inside repo/ to observe the rejection!"
