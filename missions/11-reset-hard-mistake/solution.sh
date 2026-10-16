# shellcheck shell=bash
# Solution for Mission 11: Undoing an Accidental reset --hard
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Locate the commit hash from before the reset in reflog
target_commit="$(git reflog | grep -m1 "Implement end-to-end payload encryption" | awk '{print $1}')"

# 2. Reset hard forward to restore main and working files
git reset --hard "$target_commit"
