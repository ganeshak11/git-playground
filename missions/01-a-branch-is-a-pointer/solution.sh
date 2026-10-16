# shellcheck shell=bash
# Solution for Mission 1: A Branch Is Just a Pointer
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Find the hashes of the 2nd commit and 1st commit
#    HEAD is commit 3, HEAD~1 is commit 2, HEAD~2 is commit 1
commit2="$(git rev-parse HEAD~1)"
commit1="$(git rev-parse HEAD~2)"

# 2. Create branches pointing to those commits
git branch feature-v1 "$commit2"
git branch experimental "$commit1"

# 3. Make a new commit on main
echo "## Release Notes" >> README.md
git add README.md
git commit -m "Update documentation with release notes"
