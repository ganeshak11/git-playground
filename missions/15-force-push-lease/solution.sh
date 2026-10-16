# shellcheck shell=bash
# Mission 15 reference solution:
# Push the rewritten local feature branch using --force-with-lease

cd "${SANDBOX}/repo" || exit 1

git push --force-with-lease origin feature/export-csv >/dev/null 2>&1
