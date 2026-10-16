# shellcheck shell=bash
# Solution for Mission 3: Push Rejected
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Integrate remote changes into our local branch
#    --no-edit uses the default merge commit message without opening an interactive editor
git pull --no-rebase --no-edit origin main

# 2. Push the combined history to the remote
git push origin main
