# shellcheck shell=bash
# Solution for Mission 4: Merge Conflict
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Trigger the merge conflict (|| true prevents set -e from aborting)
git pull --no-rebase origin main || true

# 2. Write the resolved code (all conflict markers removed)
cat << 'EOF' > app.py
# Task Tracker API

API_VERSION = "1.0"
APP_NAME = "TaskApp"
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets

def get_status():
    return {"status": "ok", "version": API_VERSION}
EOF

# 3. Mark the conflict as resolved
git add app.py

# 4. Commit the merge
git commit -m "Resolve pagination conflict by setting limit to 100"

# 5. Push the clean merge to remote
git push origin main
