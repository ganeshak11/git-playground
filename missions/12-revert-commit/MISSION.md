# Mission 12: Revert a Pushed Bad Commit

## The Situation
You are on duty maintaining the **Billing Service**. An urgent incident report arrives from customer operations: customers are being charged an illegal 15% surcharge fee!

Looking at the repository, you discover that a middle commit introduced a buggy `calculate_surcharge` function into `billing.py`. Worse, subsequent commits were already merged and pushed after it (including a PDF receipt generator and updated support docs).

Everything has already been pushed to `origin/main`. You need to eliminate the bad surcharge calculation immediately without breaking subsequent features or disrupting teammates.

---

## 1. The Mental Model & Under-the-Hood Mechanics

### The Golden Rule of Git History
> **Never rewrite commits that have already been pushed to a shared remote.**

When you make a mistake on your local machine before pushing, commands like `git reset` or `git commit --amend` are fine because nobody else has seen those commits.

Once a commit is pushed to a shared remote (`origin/main`), other developers pull it, automated CI pipelines build it, and production deploys it. If you use `git reset` to rewind history on a shared branch:
1. Your local branch falls behind the remote.
2. `git push` is immediately rejected with a **non-fast-forward error**.
3. If you force-push (`git push --force`), you erase commits from the remote repository, orphan your teammates' local work, and cause merge chaos for everyone on the team.

```
WHAT HAPPENS IF YOU RESET A PUSHED BRANCH:

Remote (origin/main):
  C1 ───> C2 [BUG] ───> C3 [Receipt] ───> C4 [Docs] (origin/main)

Your local after 'git reset --hard C1':
  C1 (HEAD -> main)
  
Result: Local is behind remote! 'git push' rejected.
        If force-pushed, C3 and C4 are obliterated on the remote!
```

---

### How `git revert` Works: Append-Only History
Instead of traveling back in time to delete or modify history, `git revert` is an **append-only undo**:

```
WHAT GIT REVERT DOES:

Remote & Local:
  C1 ───> C2 [BUG] ───> C3 [Receipt] ───> C4 [Docs]
                                               │
                                       git revert C2
                                               │
                                               ▼
  C1 ───> C2 [BUG] ───> C3 [Receipt] ───> C4 [Docs] ───> C5 [Revert "C2"] (HEAD -> main)
```

Behind the scenes:
1. Git examines the diff introduced by the target commit `C2`.
2. Git computes the **inverse patch**:
   - Added lines (`+`) are removed (`-`).
   - Deleted lines (`-`) are restored (`+`).
3. Git applies this inverse patch to your current working tree and staging area.
4. Git creates a brand new commit `C5` with the commit message `Revert "C2's message"`.
5. Because history only moves forward, you can push `C5` to `origin/main` as a clean, fast-forward update with zero conflicts for teammates!

---

### Reverting a Middle Commit
Notice that in our scenario, `C2` is a **middle commit** (two commits behind `HEAD`). Commits `C3` and `C4` were made after it.

Can Git revert a commit in the middle of history? **Yes!**
As long as the commits that came after (`C3` and `C4`) didn't edit the exact same lines of code in the same files, Git cleanly applies the inverse patch to the current tree without touching the subsequent features.

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git log --oneline` | View compact commit history with short hashes |
| `git show <commit>` | Inspect what changes a specific commit introduced |
| `git revert <commit>` | Compute inverse patch and open editor for commit message |
| `git revert --no-edit <commit>` | Revert without prompting for an edit to the default commit message |
| `git revert -n <commit>` | Stage the inverse patch without creating a commit (`--no-commit`) |
| `git revert --abort` | Abort a revert in progress if conflict resolution is cancelled |
| `git push origin main` | Push the new revert commit to the remote |

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Inspect commit history and identify the bad commit
```bash
git log --oneline
```
You will see 4 commits. Look for the commit that added the surcharge fee (e.g., `Add premium surcharge fee`). Note its commit hash.

### Step 3: Inspect the damage
See exactly what lines the bad commit introduced:
```bash
git show <bad-commit-hash>
```
You'll see it added `calculate_surcharge` to `billing.py`.

### Step 4: Revert the middle commit safely
Run:
```bash
git revert --no-edit <bad-commit-hash>
```
*(If you run `git revert <bad-commit-hash>` without `--no-edit`, Git opens your text editor with a pre-filled message like `Revert "Add premium surcharge fee"`. Simply save and close the editor).*

### Step 5: Verify the repository state
1. Check that `billing.py` no longer contains the surcharge:
   ```bash
   cat billing.py
   ```
2. Check that subsequent features (`receipt.py` and `README.md`) are completely intact:
   ```bash
   cat receipt.py
   cat README.md
   ```
3. Check the commit log:
   ```bash
   git log --oneline
   ```
   You should see 5 commits now, with your new revert commit sitting on top of `main`.

### Step 6: Push the revert to origin
Push your safe forward-moving fix to the remote:
```bash
git push origin main
```

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] Why should you never use `git reset` on commits that have already been pushed to a remote?
- [ ] What does `git revert <commit>` do under the hood (diff inversion vs deleting commits)?
- [ ] What happens to commits that were created *after* the commit being reverted?
- [ ] What does the `--no-edit` flag do during a revert?
