# shellcheck shell=bash
# Mission 8 check — verifies:
# 1. Working tree is clean.
# 2. HEAD is NOT detached.
# 3. Active branch is main.
# 4. The branch feature/vector-compute exists and points to the prototype commit.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree
assert_clean "${SANDBOX}/repo"

# 2. HEAD must not be detached
head_ref="$(git symbolic-ref --short HEAD 2>/dev/null || echo "DETACHED")"
if [[ "$head_ref" == "DETACHED" ]]; then
    fail "You are still in detached HEAD state! Create or switch to a branch."
fi

# 3. Active branch must be main
assert_on_branch "main"

# 4. feature/vector-compute branch must exist
assert_branch_exists "feature/vector-compute"

# 5. feature/vector-compute must point to the prototype commit
proto_commit="$(play_recall "proto_commit")"
branch_commit="$(git rev-parse feature/vector-compute 2>/dev/null)"
assert_refs_equal "$branch_commit" "feature/vector-compute" "$proto_commit" "prototype commit"

pass "Detached HEAD safely rescued into 'feature/vector-compute' branch! You understand how HEAD works."
