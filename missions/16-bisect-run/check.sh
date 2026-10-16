# shellcheck shell=bash
# Mission 16 check — verifies that the learner used git bisect to identify
# the first bad commit, recorded its hash in culprit.txt, and cleanly reset bisect.

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean (ignoring culprit.txt and pycache whether tracked or untracked)
local dirty
dirty="$(git status --porcelain 2>/dev/null | grep -Ev "(culprit\.txt|__pycache__|\.pyc)" || true)"
if [[ -n "$dirty" ]]; then
    fail "Working tree has uncommitted modifications. Run 'git status' to inspect."
fi

# 2. Must be back on main branch (not in detached HEAD)
assert_on_branch "main"

# 3. Bisect must be cleanly reset
if [[ -d ".git/BISECT_LOG" || -f ".git/BISECT_LOG" || -f ".git/BISECT_START" ]]; then
    fail "Git bisect session is still active. Run 'git bisect reset' to return to your branch."
fi

# 4. culprit.txt must exist and contain the bad commit hash
assert_file_exists "culprit.txt"

local expected_culprit user_culprit
expected_culprit="$(play_recall "culprit_hash")"
user_culprit="$(tr -d ' \r\n' < culprit.txt)"

if [[ -z "$user_culprit" ]]; then
    fail "culprit.txt is empty. Put the bad commit hash inside it."
fi

if [[ "${#user_culprit}" -lt 6 ]]; then
    fail "The commit hash in culprit.txt is too short (${#user_culprit} characters). Provide at least 7 characters."
fi

if [[ "${expected_culprit}" != "${user_culprit}"* ]]; then
    fail "The commit in culprit.txt ($user_culprit) is not the first bad commit. Run 'git bisect' again."
fi

pass "First bad commit ($user_culprit) correctly identified and bisect cleanly reset!"
