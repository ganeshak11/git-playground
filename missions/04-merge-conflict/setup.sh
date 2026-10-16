# shellcheck shell=bash
# Mission 4 setup — sets up a repository where both the local user and a teammate
# modified the exact same line in app.py, producing a merge conflict on git pull.

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

    # 3. Base initial commit
    cat << 'EOF' > app.py
# Task Tracker API

API_VERSION = "1.0"
APP_NAME = "TaskApp"
MAX_ITEMS_PER_PAGE = 20

def get_status():
    return {"status": "ok", "version": API_VERSION}
EOF

    commit_as "You" "you@example.com" "Initial release of TaskApp"
    git push -u origin main >/dev/null 2>&1

    # 4. Local commit by You (sets limit to 50)
    cat << 'EOF' > app.py
# Task Tracker API

API_VERSION = "1.0"
APP_NAME = "TaskApp"
MAX_ITEMS_PER_PAGE = 50

def get_status():
    return {"status": "ok", "version": API_VERSION}
EOF

    commit_as "You" "you@example.com" "Increase max items per page to 50"
)

# 5. Teammate Jordan pushes to the remote (sets exact same line to 100)
jordan_app="$(cat << 'EOF'
# Task Tracker API

API_VERSION = "1.0"
APP_NAME = "TaskApp"
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets

def get_status():
    return {"status": "ok", "version": API_VERSION}
EOF
)"

teammate_push "${SANDBOX}/remote.git" "Jordan" "jordan@example.com" \
    "Set pagination limit to 100 for large datasets" "app.py" "$jordan_app"

say "Repository ready at repo/."
say "You changed MAX_ITEMS_PER_PAGE to 50; teammate Jordan pushed 100 to remote.git."
say "Run 'git pull origin main' inside repo/ to trigger the merge conflict!"
