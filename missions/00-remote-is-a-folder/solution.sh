# shellcheck shell=bash
# Solution for Mission 0: Remote Is Just a Folder
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.
# Uses plain git commands — no lib helpers — because these are what she types.

cd "${SANDBOX}"

# 1. Create a bare repository — this is what GitHub is behind the scenes.
#    --initial-branch=main ensures everyone agrees on the branch name.
git init --bare --initial-branch=main team-remote.git

# 2. Clone from it — just like 'git clone https://github.com/...'
#    except the URL is a folder path.
git clone team-remote.git my-project

# 3. Configure identity in the clone (local only, not global)
git -C my-project config user.name "You"
git -C my-project config user.email "you@example.com"
git -C my-project config core.autocrlf false

# 4. Create a file, commit, and push
cd my-project
echo "# Task Tracker" > README.md
echo "A simple task tracking app." >> README.md
git add README.md
git commit -m "Initial commit: add README"
git push origin main
cd ..

# 5. Clone a second time — both clones now share the same history
git clone team-remote.git teammate-clone
