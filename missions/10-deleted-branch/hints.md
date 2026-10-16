## Hint 1

Deleting a branch with `git branch -D` only removes the branch pointer file — it does **not** delete the commits!
All your commits are still recorded in Git's local history log.

To see every recent commit you've made, run:

    git reflog

## Hint 2

Run `git reflog` and look through the list for:
`commit: Implement inverted index search algorithm`

On the left side of that line is the 7-character commit hash (e.g. `7a3b4c5`).
To resurrect the branch, pass that hash to `git branch`:

    git branch feature/search-indexing <that-hash>

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. View recent commits in reflog
git reflog

# 2. Recreate the branch at the commit hash found in reflog:
# (Replace 7a3b4c5 with your actual hash, or use this command):
hash="$(git reflog | grep -m1 "Implement inverted index" | awk '{print $1}')"
git branch feature/search-indexing "$hash"

# 3. Verify the branch is restored
git log --oneline feature/search-indexing
```
