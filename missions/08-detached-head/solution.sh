# shellcheck shell=bash
# Solution for Mission 8: Detached HEAD
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo" || exit 1

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Attach a new branch to the current detached HEAD
git switch -c feature/vector-compute

# 2. Switch back to main
git switch main
