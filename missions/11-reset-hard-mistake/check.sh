# shellcheck shell=bash
# Mission 11 check — verifies:
# 1. Working tree is clean and on branch main.
# 2. Total commits on main is 3 (both undone commits restored).
# 3. HEAD matches the tip from before the reset.
# 4. crypto.py has all restored functions.

if [[ ! -d "${SANDBOX}/repo/.git" ]]; then
    fail "No git repository found at 'repo/'."
fi

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Clean working tree and on main
assert_clean "${SANDBOX}/repo"
assert_on_branch "main"

# 2. Exactly 3 commits on main
assert_commit_count "main" 3

# 3. HEAD must match the tip from before the reset
expected_tip="$(play_recall "saved_tip")"
actual_tip="$(git rev-parse HEAD)"
assert_refs_equal "$actual_tip" "main HEAD" "$expected_tip" "expected tip before reset"

# 4. crypto.py contains all restored code
assert_file_contains "${SANDBOX}/repo/crypto.py" "generate_keys"
assert_file_contains "${SANDBOX}/repo/crypto.py" "encrypt_payload"

pass "Accidental reset undone! All commits and working files restored using the reflog."
