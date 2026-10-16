# shellcheck shell=bash
# Mission 12 reference solution
# 1. Identify the bad commit introducing the fee
# 2. Revert that specific commit using git revert --no-edit
# 3. Push the new revert commit to origin/main

cd "${SANDBOX}/repo" || exit 1

# Locate the bad commit hash by commit message
bad_commit="$(git log --grep="Add premium surcharge fee" --format="%H" -1)"

if [[ -z "$bad_commit" ]]; then
    echo "Could not find bad commit in history" >&2
    exit 1
fi

# Revert without opening an interactive editor
git revert --no-edit "$bad_commit" >/dev/null 2>&1

# Push the revert to the remote repository
git push origin main >/dev/null 2>&1
