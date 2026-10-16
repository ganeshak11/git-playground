# shellcheck shell=bash
# Mission 9 setup — creates a repository with an initial commit,
# followed by a commit with a typo in its message ("biometirc"),
# and an untracked forgotten test file (test_auth.py).

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Base project on main
    cat << 'EOF' > README.md
# Authentication Service
Secure authentication module.
EOF

    cat << 'EOF' > auth.py
def login(username, password):
    return username == "admin" and password == "secret"
EOF

    commit_as "You" "you@example.com" "Initial authentication setup"

    # 2. Imperfect commit with typo
    cat << 'EOF' > auth.py
def login(username, password):
    return username == "admin" and password == "secret"

def login_biometric(biometric_token):
    return biometric_token == "valid_token"
EOF

    commit_as "You" "you@example.com" "Add biometirc auth support"

    # 3. Forgotten untracked test file
    cat << 'EOF' > test_auth.py
from auth import login_biometric

def test_biometric():
    assert login_biometric("valid_token") is True
EOF
)

say "Repository ready at repo/."
say "You just made a commit with a typo in the message ('biometirc'),"
say "and realized you forgot to stage 'test_auth.py'!"
say "Use 'git commit --amend' to fix the message and include test_auth.py in a single clean commit!"
