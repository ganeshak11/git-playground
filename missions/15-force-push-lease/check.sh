# shellcheck shell=bash
# Mission 15 check — verifies that the rewritten local commit on feature/export-csv
# was successfully pushed to origin using --force-with-lease.

cd "${SANDBOX}/repo" || fail "Cannot enter repo directory."

# 1. Working tree clean and on feature branch
assert_clean
assert_on_branch "feature/export-csv"

# 2. Remote tracking ref must match local HEAD
local_head="$(git rev-parse HEAD)"
remote_head="$(git -C "${SANDBOX}/remote.git" rev-parse feature/export-csv 2>/dev/null)"

if [[ -z "$remote_head" ]]; then
    fail "Remote branch origin/feature/export-csv does not exist on remote."
fi

if [[ "$local_head" != "$remote_head" ]]; then
    fail "Remote origin/feature/export-csv (${remote_head:0:7}) does not match local HEAD (${local_head:0:7}). Did you push with 'git push --force-with-lease'?"
fi

# 3. Commit should be the amended version with UTF-8 formatting
assert_msg "HEAD" "UTF-8 formatting"

# 4. File contents verified
assert_file_exists "csv_exporter.py"
assert_file_contains "csv_exporter.py" "UTF-8 encoding"

pass "Remote feature branch successfully updated using --force-with-lease!"
