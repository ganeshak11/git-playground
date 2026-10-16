# shellcheck shell=bash
# Solution for Mission 10: Rescuing a Deleted Branch
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Locate the commit hash from reflog
commit_hash="$(git reflog | grep -m1 "Implement inverted index" | awk '{print $1}')"

# 2. Resurrect the branch pointing to that commit
git branch feature/search-indexing "$commit_hash"
