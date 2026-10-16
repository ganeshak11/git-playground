## Hint 1

To see the commits on the experimental branch without leaving `main`, run:

    git log --oneline experiment/next-gen-ui

Find the commit hash for the one that says `"Fix critical SQL injection vulnerability in db.py"`.
Once you have the hash, you can cherry-pick it onto your current branch with `git cherry-pick <commit-hash>`.

## Hint 2

Make sure you are on branch `main` (`git branch`).

Run:
```bash
git log --oneline experiment/next-gen-ui
```
You will see 3 commits. The middle one (by SecurityTeam) contains the fix.
Copy that 7-character commit hash (e.g. `abc1234`), then run:

```bash
git cherry-pick <that-hash>
```

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. View the commit history of the experimental branch
git log --oneline experiment/next-gen-ui

# 2. Grab the hash for the SQL injection fix and cherry-pick it:
# (Or use git log filter to grab it automatically):
bugfix="$(git log experiment/next-gen-ui --grep="Fix critical SQL injection" --format="%h" -1)"
git cherry-pick "$bugfix"

# 3. Check that it was applied to main
git log -1
```
