# shellcheck shell=bash
# Mission 7 setup — builds a repository with a clean main branch,
# and an experimental branch with 3 commits: UI redesign, SQL injection fix, and WIP 3D code.

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Base project on main
    cat << 'EOF' > README.md
# Database Service
Secure database access layer.
EOF

    cat << 'EOF' > db.py
def query(sql):
    print(f"Executing: {sql}")
    return []
EOF

    cat << 'EOF' > ui.py
def render():
    return "<div>Standard UI</div>"
EOF

    commit_as "You" "you@example.com" "Initial database and UI setup"

    # 2. Create experimental branch
    git switch -c experiment/next-gen-ui >/dev/null 2>&1

    # Commit 1 on experiment: Layout redesign
    cat << 'EOF' > ui.py
def render():
    return "<div class='modern'>Modern Layout v2</div>"
EOF
    commit_as "Alex" "alex@example.com" "Experimental layout redesign"

    # Commit 2 on experiment: Critical security fix in db.py
    cat << 'EOF' > db.py
def query(sql, params=None):
    # FIX: sanitize inputs to prevent SQL injection
    sanitized = sql.replace("'", "''")
    print(f"Executing: {sanitized}")
    return []
EOF
    commit_as "SecurityTeam" "security@example.com" "Fix critical SQL injection vulnerability in db.py"
    play_store "bugfix_hash" "$(git rev-parse HEAD)"

    # Commit 3 on experiment: WIP unfinished 3D animations
    cat << 'EOF' > ui.py
def render():
    # BROKEN WIP: ThreeJS WebGL 3D Canvas
    return "<canvas id='3d-view'></canvas>"
EOF
    commit_as "Alex" "alex@example.com" "WIP unfinished 3D animations"

    # 3. Switch back to main
    git switch main >/dev/null 2>&1
)

say "Repository ready at repo/ on branch 'main'."
say "Branch 'experiment/next-gen-ui' contains a critical SQL injection fix by SecurityTeam."
say "Inspect it with 'git log --oneline experiment/next-gen-ui' and cherry-pick the fix onto main!"
