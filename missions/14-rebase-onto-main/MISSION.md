# Mission 14: Rebase Onto Moved Main

## The Situation
You are working on the **Search Application**. Earlier this morning, you branched off `main` to create a new branch: `feature/search-filter`. You wrote a search query parser and committed your changes.

Meanwhile, your teammates worked on another critical piece of infrastructure: database indexing. They finished their work and merged 2 new commits into `main`.

Now your feature branch is out of date. You need the latest database changes, and your team enforces a **clean, linear history** policy for all Pull Requests. You must rebase your feature branch onto the updated `main`.

---

## 1. The Mental Model & Under-the-Hood Mechanics

### What Happens When Branches Diverge
When you branch off `main` at commit `A`, both branches share the same starting point. But software development is asynchronous:
- You add commits `F1` and `F2` on `feature/search-filter`.
- Teammates add commits `M1` and `M2` on `main`.

```
DIVERGENT HISTORY:

        M1 ───> M2 (main)
       /
A ────
       \
        F1 ───> F2 (feature/search-filter, HEAD)
```

At this point, `feature/search-filter` does not have access to `M1` or `M2` (such as `db.py`).

---

### Merge vs. Rebase: Two Ways to Catch Up

| Strategy | Command | What happens | Resulting History |
|---|---|---|---|
| **Merge** | `git merge main` | Creates a new "merge commit" with two parents, tying the two branch tips together. | Non-linear: braided, criss-crossing branches with extra merge commits. |
| **Rebase** | `git rebase main` | Unplugs your feature commits, moves your branch to the tip of `main`, and replays your commits one by one on top. | **Linear:** a single, straight line of commits as if you started coding today. |

---

### Under the Hood: The 4 Steps of Rebase
When you run `git rebase main` while on `feature/search-filter`:

1. **Find the common ancestor:** Git identifies commit `A`, where `feature/search-filter` originally branched off `main`.
2. **Store patches:** Git calculates the diff for each of your feature commits (`F1`, `F2`) and saves them as temporary patches.
3. **Reset branch pointer:** Git resets your feature branch pointer to the target branch (`main` at `M2`).
4. **Replay patches:** Git applies each saved patch in order onto `M2`, creating brand new commits (`F1'`, `F2'`).

```
THE REBASE PROCESS:

Step 1 & 2: Save diffs for F1 and F2.
Step 3: Fast-forward branch pointer to M2:
  A ───> M1 ───> M2 (main, feature/search-filter)

Step 4: Replay F1 as F1', then replay F2 as F2':
  A ───> M1 ───> M2 (main) ───> F1' ───> F2' (feature/search-filter, HEAD)
```

> **Why do F1' and F2' have apostrophes?**
> Because they have different parent commits (`M2` instead of `A`), their cryptographic commit hashes **change**. Rebase rewrites history to make it linear. This is completely safe on your private feature branch before sharing it!

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git log --graph --oneline --all` | Visualizes all branches and how they diverge or connect |
| `git rebase <base-branch>` | Replays current branch commits on top of `<base-branch>` |
| `git rebase --abort` | Cancels the rebase and restores the pre-rebase state |
| `git rebase --continue` | Resumes rebase after manually resolving a conflict |

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Visualize the diverged branches
Run:
```bash
git log --graph --oneline --all
```
Look at the ASCII tree:
- Notice `main` has moved ahead with commits about database indexing.
- Notice `feature/search-filter` splits off from the initial foundation commit.

### Step 3: Verify your current branch
Make sure you are on your feature branch:
```bash
git branch --show-current
```
*(If not on `feature/search-filter`, switch to it with `git switch feature/search-filter`).*

### Step 4: Rebase onto main
Run:
```bash
git rebase main
```
Git will output:
```text
Successfully rebased and updated refs/heads/feature/search-filter.
```

### Step 5: Admire the clean linear history
Run:
```bash
git log --graph --oneline
```
Notice:
- No merge commits!
- The history is a single, beautiful straight line.
- The database commits from `main` come first, followed by your search commits.

### Step 6: Verify the code
Check that you have both the database files from `main` and your search files:
```bash
ls -la
cat db.py
cat search.py
```

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] What is the visual difference in `git log --graph` between a merged branch and a rebased branch?
- [ ] Why do your feature commits get new SHA hashes after a rebase?
- [ ] What 4 steps does Git perform under the hood during a rebase?
- [ ] What command cancels an in-progress rebase and returns everything to normal?
