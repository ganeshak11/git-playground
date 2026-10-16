# shellcheck shell=bash
# Mission 14 setup — creates a repository where main has moved forward with 2 commits
# while the user was working on a feature branch (feature/search-filter).
# The learner must rebase feature/search-filter onto the updated main.

make_repo "repo"

(
    cd "${SANDBOX}/repo" || exit 1

    # Base commit on main
    cat << 'EOF' > README.md
# Search Application
Fast catalog search service.
EOF

    cat << 'EOF' > app.py
def run():
    print("Search service running...")
EOF

    commit_as "You" "you@example.com" "Initial project foundation"

    # Create feature branch
    git switch -c feature/search-filter >/dev/null 2>&1

    # Feature commit 1
    cat << 'EOF' > search.py
def search_query(query):
    return [f"result for {query}"]
EOF
    commit_as "You" "you@example.com" "Add search query parser"

    # Feature commit 2
    cat << 'EOF' > search.py
def search_query(query, category=None):
    # filter by category if provided
    if category:
        return [f"result for {query} in {category}"]
    return [f"result for {query}"]
EOF
    commit_as "You" "you@example.com" "Add filter by category to search"

    # Teammates moved main forward
    git switch main >/dev/null 2>&1

    cat << 'EOF' > db.py
def connect():
    return "Connected to indexed DB"
EOF
    commit_as "Teammate" "team@example.com" "Add database indexing configuration"

    cat << 'EOF' >> README.md

## Database
Uses indexed DB storage for high performance.
EOF
    commit_as "Teammate" "team@example.com" "Update README with database documentation"

    # Switch back to feature branch for learner
    git switch feature/search-filter >/dev/null 2>&1
)

say "Repository ready at repo/ on branch 'feature/search-filter'."
say "While you were working, teammates pushed 2 new commits to 'main'."
say "Run 'git log --graph --oneline --all' to see how the branches diverged."
say "Rebase your feature branch onto main to bring it up to date with a linear history!"
