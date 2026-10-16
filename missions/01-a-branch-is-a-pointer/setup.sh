# shellcheck shell=bash
# Mission 1 setup — builds a repository with 3 sequential commits on main.
# Stores the commit hashes in .play/ metadata for check.sh verification.

make_repo "repo"

(
    cd "${SANDBOX}/repo" || exit 1

    # Commit 1 (root)
    echo "# Task Tracker" > README.md
    echo "A lightweight task tracking application." >> README.md
    commit_as "You" "you@example.com" "Add basic project files"
    commit1="$(git rev-parse HEAD)"
    play_store "commit1" "$commit1"

    # Commit 2
    echo "function listTasks() { return []; }" > tasks.js
    commit_as "You" "you@example.com" "Implement task list feature"
    commit2="$(git rev-parse HEAD)"
    play_store "commit2" "$commit2"

    # Commit 3
    echo "function completeTask(id) { return true; }" >> tasks.js
    commit_as "You" "you@example.com" "Add task completion status"
    commit3="$(git rev-parse HEAD)"
    play_store "commit3" "$commit3"
)

say "Repository initialized at repo/ with 3 commits on main."
say "Inspect the history with 'git log --oneline' to see their hashes."
