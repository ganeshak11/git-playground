# shellcheck shell=bash
# Solution for Mission 9: Amend a Commit
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo" || exit 1

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Stage the forgotten test file
git add test_auth.py

# 2. Amend the previous commit, folding in test_auth.py and correcting the message
git commit --amend -m "Add biometric auth support and unit tests"
