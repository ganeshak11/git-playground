## Hint 1

You are currently in a detached HEAD state.
If you switch away now with `git switch main`, this prototype commit will have no branch pointing to it and will become an orphan.

To rescue it, give the current commit a branch name before you leave.

## Hint 2

Run:
```bash
git switch -c feature/vector-compute
```
This does two things:
1. Creates a new branch named `feature/vector-compute` pointing to your prototype commit.
2. Attaches `HEAD` to that new branch.

Once attached, you can safely return to `main` with `git switch main`.

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Attach a new branch to the current detached commit
git switch -c feature/vector-compute

# 2. Return to main
git switch main
```
