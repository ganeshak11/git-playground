# shellcheck shell=bash
# Mission 14 reference solution:
# Rebase the current feature branch onto main

cd "${SANDBOX}/repo" || exit 1

git switch feature/search-filter >/dev/null 2>&1
git rebase main >/dev/null 2>&1
