# shellcheck shell=bash
# Mission 13 check — verifies that the learner used interactive rebase to:
# 1. Squash the typo fix commit into the avatar upload commit
# 2. Drop the temporary debug commit
# 3. Leave exactly 2 clean commits ahead of main with working code

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on feature branch
assert_clean
assert_on_branch "feature/profile-system"

# 2. No rebase in progress
if [[ -d ".git/rebase-merge" || -d ".git/rebase-apply" ]]; then
    fail "An interactive rebase is still in progress. Finish it or run 'git rebase --abort'."
fi

# 3. Branch must have exactly 2 commits ahead of main
assert_commit_count "main..HEAD" 2

# 4. Debug print must be gone from profile.py and from the commit log
if grep -q "DEBUG" profile.py 2>/dev/null; then
    fail "profile.py still contains the temporary debug statement. Did you drop that commit?"
fi

if git log main..HEAD --oneline | grep -qi "debug"; then
    fail "A commit with 'debug' is still in your branch history. Did you drop that commit?"
fi

# 5. User profile model must be intact
assert_file_contains "profile.py" "class UserProfile:"
assert_file_contains "profile.py" "self.bio = bio"

# 6. Avatar feature must be present and include the typo fix from the squashed commit
assert_file_exists "avatar.py"
assert_file_contains "avatar.py" "clean_id"

pass "Interactive rebase complete! Typo fix squashed and debug commit dropped cleanly."
