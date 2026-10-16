# shellcheck shell=bash
# Mission 13 setup — creates a repository with a main branch and a feature branch
# containing 4 commits:
# 1. Add user profile model (valid, keep)
# 2. Add avatar upload feature (valid, keep)
# 3. Fix typo in avatar upload (incremental, should be squashed into #2)
# 4. Add temporary debug print (accidental dev debug log, should be dropped)

make_repo "repo"

(
    cd "${SANDBOX}/repo" || exit 1

    # Base commit on main
    cat << 'EOF' > README.md
# User Profile Service
Manages user profile data and avatars.
EOF

    cat << 'EOF' > profile.py
class UserProfile:
    def __init__(self, username):
        self.username = username
EOF

    commit_as "You" "you@example.com" "Initial project setup"

    # Switch to feature branch
    git switch -c feature/profile-system >/dev/null 2>&1

    # Commit 1: User profile model update
    cat << 'EOF' > profile.py
class UserProfile:
    def __init__(self, username, email, bio=""):
        self.username = username
        self.email = email
        self.bio = bio
EOF
    commit_as "You" "you@example.com" "Add user profile model"

    # Commit 2: Avatar upload feature
    cat << 'EOF' > avatar.py
def upload_avatar(user_id, image_data):
    return f"/avatars/{user_id}.png"
EOF
    commit_as "You" "you@example.com" "Add avatar upload feature"

    # Commit 3: Fix typo in avatar upload (incremental fix)
    cat << 'EOF' > avatar.py
def upload_avatar(user_id, image_data):
    # Strip whitespace from user_id
    clean_id = str(user_id).strip()
    return f"/avatars/{clean_id}.png"
EOF
    commit_as "You" "you@example.com" "Fix typo in avatar upload"

    # Commit 4: Accidental debug print
    cat << 'EOF' > profile.py
# DEBUG: temporary dev inspection - DO NOT SHIP
print("DEBUG: auth tokens logged to console")

class UserProfile:
    def __init__(self, username, email, bio=""):
        self.username = username
        self.email = email
        self.bio = bio
EOF
    commit_as "You" "you@example.com" "Add temporary debug print"
)

say "Repository ready at repo/ on branch 'feature/profile-system'."
say "Your branch has 4 commits ahead of main, including a typo fix and a debug commit."
say "Use interactive rebase ('git rebase -i main') to squash the typo fix and drop the debug commit!"
