# Mission 15: Force-Push After Rebase (--force-with-lease)

## The Situation
You are building a CSV export feature on `feature/export-csv`. Earlier, you pushed your initial version to the remote repository so your teammates could track your progress.

After pushing, you realized your CSV output needed UTF-8 encoding headers. You made the fix and amended your commit (`git commit --amend`) to keep your branch history clean.

Now you run `git push` to publish your update, but Git slaps you with an error:
```text
 ! [rejected]        feature/export-csv -> feature/export-csv (non-fast-forward)
error: failed to push some refs to '...'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart.
```

Why did Git reject your push, and what is the safe, modern way to update your remote feature branch?

---

## 1. The Mental Model & Under-the-Hood Mechanics

### Why Non-Fast-Forward Rejections Happen After Rebase/Amend
When you amend a commit or rebase a branch, Git generates a **brand new commit SHA**. It does not modify the old commit in place.

- On the remote (`origin/feature/export-csv`), the branch pointer points to the **old** commit `C1`.
- On your computer, your local branch pointer points to the **new** commit `C1'`.

```
WHAT GIT SEES AT THE REMOTE:

Remote branch:
  origin/feature/export-csv ───> [ C1: Old Commit ]

Your local branch:
  feature/export-csv        ───> [ C1': Amended Commit ]
```

Because `C1` is not an ancestor of `C1'`, Git considers this a non-fast-forward update. By default, Git refuses to overwrite remote commits because doing so usually means somebody is about to lose work.

---

### The Sledgehammer: Why `git push --force` (`-f`) is Dangerous
Many tutorials tell beginners to run `git push --force`. **Do not do this.**

Here is why `--force` is dangerous on real teams:
1. You spend an hour amending or rebasing your branch locally.
2. In that hour, your teammate Bob pushes a commit to your remote branch (e.g., adding unit tests or fixing a typo).
3. You run `git push --force`.
4. Git **blindly overwrites** the remote branch with your local version. Bob's commits are destroyed on the remote without any warning!

```
THE DANGER OF --force:

Remote:
  C1 ───> Bob's Commit [C2]

Your local:
  C1' (amended C1)

Running 'git push --force':
Remote is forcibly overwritten with C1'! Bob's C2 is obliterated!
```

---

### The Professional Safety Standard: `--force-with-lease`
Instead of blindly forcing, Git provides a safety mechanism called **lease checking**:
```bash
git push --force-with-lease
```

Think of it as conditional overwriting:
> *"Git, I want to update the remote branch with my rewritten history, **BUT ONLY IF** the remote branch is still at the exact commit I last saw (`C1`). If anyone else has pushed new commits since my last fetch, refuse to push and stop me."*

```
HOW --force-with-lease PROTECTS YOUR TEAM:

Scenario A (Nobody pushed):
  Remote is still at C1 (matches your expected lease).
  --> SUCCESS: Remote updates smoothly to C1'.

Scenario B (Teammate Bob pushed C2):
  Remote is at C2 (lease check FAILS!).
  --> REJECTED: Git aborts with "stale info", protecting Bob's work!
```

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git push` | Standard safe push (requires fast-forward) |
| `git push --force` (`-f`) | **Dangerous.** Blindly overwrites remote branch pointer |
| `git push --force-with-lease` | **Safe standard.** Overwrites remote only if no one else has pushed |
| `git fetch origin` | Downloads latest remote refs without modifying your working files |

> [!IMPORTANT]
> **The Golden Rule:** Never force-push (even with lease) to `main`, `master`, or any shared integration branch. Only force-push to your own personal feature branches!

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Observe the hash divergence
Compare the commit hash on your local branch against the remote tracking branch:
```bash
git log --oneline -1 feature/export-csv
git log --oneline -1 origin/feature/export-csv
```
Notice that the commit titles and hashes are different! Local has the amended UTF-8 commit, while remote has the older commit.

### Step 3: Try a normal push to see the rejection
```bash
git push
```
Observe Git's rejection message and read the hint.

### Step 4: Push safely using `--force-with-lease`
Run:
```bash
git push --force-with-lease
```
Git will output:
```text
 + <old-hash>...<new-hash> feature/export-csv -> feature/export-csv (forced update)
```

### Step 5: Verify the remote branch is in sync
Check that both local and remote now share the identical amended commit:
```bash
git log --oneline -1 origin/feature/export-csv
```

### Step 6: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] Why does amending or rebasing a commit cause Git to reject a normal `git push`?
- [ ] What is the critical risk of using `git push --force` on a team?
- [ ] How does `--force-with-lease` detect if a teammate pushed commits while you were rebasing?
- [ ] What branches should you NEVER force-push to?
