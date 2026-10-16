# Git Cheatsheet: The 20 Commands You Actually Need

One line each. No fluff.

## Looking Around
1. **`git status`** — See modified, staged, and untracked files in your working tree.
2. **`git diff`** — Show unstaged changes between your working tree and staging.
3. **`git diff --staged`** — Show changes between staged files and the last commit.
4. **`git log --oneline --graph --all`** — Visual branch graph showing history and all branches.
5. **`git show <ref>`** — Inspect the commit details and file diff for a given commit.

## Making Changes
6. **`git add <file>`** — Stage changes in `<file>` ready for commit.
7. **`git add -p`** — Interactively review and stage changes hunk by hunk.
8. **`git commit -m "<msg>"`** — Record staged changes into a new commit.
9. **`git commit --amend`** — Modify the most recent commit (message or staged files).

## Branches & Switching
10. **`git branch <name>`** — Create a new branch pointing to current HEAD.
11. **`git switch <branch>`** — Switch to an existing branch (modern alternative to checkout).
12. **`git switch -c <branch>`** — Create and switch to a new branch in one step.
13. **`git branch -d <branch>`** — Safely delete a branch that has been merged (`-D` to force).

## Synchronizing with Remotes
14. **`git fetch origin`** — Download all new commits and branches from remote without merging.
15. **`git pull`** — Fetch remote changes and merge/rebase them into your active branch.
16. **`git push origin <branch>`** — Send your local branch commits to the remote.

## Undoing & Recovering
17. **`git restore <file>`** — Discard uncommitted changes in `<file>` to match HEAD.
18. **`git restore --staged <file>`** — Unstage changes in `<file>` while keeping working edits.
19. **`git reset --soft HEAD~1`** — Undo the last commit but keep changes staged.
20. **`git reflog`** — View the chronological log of all HEAD movements to recover "lost" commits.

---

> [!TIP]
> **Stuck in a pager (`git log` or `git diff`)?** Press `q` to quit.
> **Stuck in Vim?** Press `Esc`, type `:wq`, and press `Enter`.
