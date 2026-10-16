# shellcheck shell=bash
# Mission 11 setup — builds a repository with 3 commits on main,
# stores the tip hash, then executes 'git reset --hard HEAD~2' to simulate
# an accidental destructive reset.

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Base project on main
    cat << 'EOF' > README.md
# Cryptographic Messaging Service
End-to-end encrypted messaging service.
EOF

    cat << 'EOF' > crypto.py
# Crypto library base
VERSION = "1.0"
EOF

    commit_as "You" "you@example.com" "Initial crypto service setup"

    # 2. Second commit on main
    cat << 'EOF' > crypto.py
VERSION = "1.0"

def generate_keys():
    return {"public": "pub_key_123", "private": "priv_key_456"}
EOF
    commit_as "You" "you@example.com" "Add cryptographic keypair generation"

    # 3. Third commit on main
    cat << 'EOF' > crypto.py
VERSION = "1.0"

def generate_keys():
    return {"public": "pub_key_123", "private": "priv_key_456"}

def encrypt_payload(data, public_key):
    return f"ENCRYPTED({data}):{public_key}"
EOF
    commit_as "You" "you@example.com" "Implement end-to-end payload encryption"
    play_store "saved_tip" "$(git rev-parse HEAD)"

    # 4. The accidental destructive reset!
    git reset --hard HEAD~2 >/dev/null 2>&1
)

say "Repository ready at repo/ on branch 'main'."
say "An accidental 'git reset --hard HEAD~2' just rewound main and wiped two commits!"
say "Use 'git reflog' to find the lost commit hash and restore main forward!"
