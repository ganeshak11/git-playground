# shellcheck shell=bash
# Mission 10 setup — builds a repository with an initial commit on main,
# creates feature/search-indexing with 2 commits, switches to main, and deletes the feature branch.

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Base project on main
    cat << 'EOF' > README.md
# Search Engine Core
Fast in-memory full-text search.
EOF

    cat << 'EOF' > search.py
def search(query):
    return []
EOF

    commit_as "You" "you@example.com" "Initial search engine setup"

    # 2. Create feature branch and commits
    git switch -c feature/search-indexing >/dev/null 2>&1

    cat << 'EOF' > tokenizer.py
def tokenize(text):
    return text.lower().split()
EOF
    commit_as "You" "you@example.com" "Add tokenizer module"

    cat << 'EOF' > search.py
from tokenizer import tokenize

def build_index(documents):
    index = {}
    for doc_id, text in documents.items():
        for token in tokenize(text):
            index.setdefault(token, set()).add(doc_id)
    return index

def search(query, index):
    return index.get(query.lower(), set())
EOF
    commit_as "You" "you@example.com" "Implement inverted index search algorithm"
    play_store "search_commit" "$(git rev-parse HEAD)"

    # 3. Switch back to main and delete the branch
    git switch main >/dev/null 2>&1
    git branch -D feature/search-indexing >/dev/null 2>&1
)

say "Repository ready at repo/ on branch 'main'."
say "The branch 'feature/search-indexing' was accidentally deleted!"
say "Open 'git reflog' to find the deleted commit and resurrect the branch!"
