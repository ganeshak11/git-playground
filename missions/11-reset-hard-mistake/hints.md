## Hint 1

Commits are not erased by `git reset --hard` — only the branch pointer moved backward.
Open `git reflog` to see everywhere `HEAD` was pointing recently.

## Hint 2

In `git reflog`, look for:
`HEAD@{0}: reset: moving to HEAD~2`

The commit right before it (`HEAD@{1}`) is the commit you want to return to:
`commit: Implement end-to-end payload encryption`

Copy that 7-character commit hash (e.g. `f9e8d7c`).
To jump forward and restore everything:

    git reset --hard <that-hash>

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. View reflog history
git reflog

# 2. Reset hard forward to the commit right before the reset:
# (Replace with your actual hash, or use this command):
hash="$(git reflog | grep -m1 "Implement end-to-end payload encryption" | awk '{print $1}')"
git reset --hard "$hash"

# Alternatively, you can use the relative reflog syntax directly:
# git reset --hard HEAD@{1}

# 3. Verify all commits are back
git log --oneline
```
