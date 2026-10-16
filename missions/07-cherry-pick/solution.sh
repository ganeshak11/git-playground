# shellcheck shell=bash
# Solution for Mission 7: Cherry-Pick
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo" || exit 1

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Find the commit hash on the experimental branch
bugfix_commit="$(git log experiment/next-gen-ui --grep="Fix critical SQL injection" --format="%H" -1)"

# 2. Cherry-pick the security fix onto main
git cherry-pick "$bugfix_commit"
