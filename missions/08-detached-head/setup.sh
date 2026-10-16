# shellcheck shell=bash
# Mission 8 setup — creates a repository with two commits on main,
# checks out the root commit in detached HEAD mode, and records a prototype commit.

make_repo "repo"

(
    cd "${SANDBOX}/repo" || exit 1

    # 1. First commit on main
    cat << 'EOF' > README.md
# Analytics Engine
High-performance analytics compute module.
EOF

    cat << 'EOF' > engine.py
def compute():
    return [10, 20, 30]
EOF

    commit_as "You" "you@example.com" "Initial analytics setup"
    commit1="$(git rev-parse HEAD)"

    # 2. Second commit on main
    cat << 'EOF' > engine.py
def compute():
    return [10, 20, 30, 40]
EOF

    commit_as "You" "you@example.com" "Expand compute metrics"

    # 3. Check out commit 1 directly (enters detached HEAD state)
    git checkout "$commit1" >/dev/null 2>&1

    # 4. Commit while detached
    cat << 'EOF' > engine.py
def compute():
    # Experimental fast compute using vectorization
    return [x * 2 for x in [10, 20, 30]]
EOF

    commit_as "You" "you@example.com" "Prototype vectorized compute"
    play_store "proto_commit" "$(git rev-parse HEAD)"
)

say "Repository ready at repo/ in a detached HEAD state on a prototype commit!"
say "Inspect it with 'git status' and 'cat .git/HEAD' to see what detached HEAD looks like."
say "Rescue the commit onto branch 'feature/vector-compute', then switch back to 'main'!"
