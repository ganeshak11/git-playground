# Mission 3: Push Rejected

---

## 1. The Mental Model: Why Does Git Reject a Push?

Every developer encounters this red error message sooner or later:

```text
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'origin'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
```

To beginners, this error feels like Git is broken or their work is ruined.
In reality, **Git is protecting your team from data loss.**

---

## 2. Fast-Forward vs. Non-Fast-Forward

To understand why Git rejected your push, visualize how Git branches move.

### The Fast-Forward Push (Normal Case)
When nobody else has pushed to the remote while you were working:

```
Remote:  [Commit A] ------------------------> [Commit B]
Local:   [Commit A] ---> [Commit B] (ahead)
```

Your local branch is directly ahead of the remote. Git can simply "fast-forward" the remote pointer from A to B. No history is lost.

### The Non-Fast-Forward Push (Rejected Case)
Suppose you and your coworker Alex both cloned from `Commit A`.
1. Alex makes a commit and pushes it to `origin/main`.
2. Meanwhile, you make your own commit on your local `main`.

Now your histories have **diverged**:

```
                       [Alex's Commit]  <-- origin/main (on remote)
                      /
    [Shared Base: A]
                      \
                       [Your Commit]    <-- main (on your machine)
```

If Git allowed you to push right now, **Alex's commit would be erased from the remote!**
Because Git refuses to overwrite commits on a remote without warning, it rejects your push.

---

## 3. The Safe Workflow: Fetch, Inspect, Integrate

When Git rejects your push, your job is to **integrate** the remote's new commits into your branch first before pushing again.

### Step 1: `git fetch origin`
- Downloads all commits from the remote without modifying your working files.
- Updates the remote-tracking branch: `origin/main`.
- Safe and non-destructive.

### Step 2: Inspect with `git log --graph --all --oneline`
You can see the fork in history right in your terminal:
```text
* 7f2a1b3 (HEAD -> main) Add user settings task
| * c49d8e2 (origin/main) Add notifications task
|/
* 3b8c1a0 Shared base commit
```

### Step 3: Integrate with `git pull`
`git pull` runs `git fetch` and integrates the remote commits into your active branch.

There are two primary integration methods:

#### Method A: Merge (`git pull --no-rebase origin main`)
Git creates a new **merge commit** with two parents, tying both branches together:

```
                       [Alex's Commit] ------------
                      /                            \
    [Shared Base: A]                                [Merge Commit] <-- main
                      \                            /
                       [Your Commit] --------------
```

#### Method B: Rebase (`git pull --rebase origin main`)
Git temporarily lifts your commit off history, updates your branch to match `origin/main`, and reapplies your commit on top:

```
    [Shared Base: A] ---> [Alex's Commit] ---> [Your Commit'] <-- main
```

*For this mission, either method will successfully unify history!*

---

## 4. Useful Commands for This Mission

- `git push origin main`
  Attempts to push local commits to `origin`.

- `git fetch origin`
  Downloads remote commits and updates `origin/main` without touching your files.

- `git log --oneline --graph --all`
  Renders a visual graph showing where local `main` and remote `origin/main` currently point.

- `git pull origin main`
  Fetches remote changes and merges them into your current branch.

---

## 5. Your Mission Tasks

You are in a repository at `repo/`.
- You made a local commit adding a user settings task to `tasks.txt`.
- Your teammate Alex already pushed a commit adding `notifications.txt` to the remote bare repo (`remote.git`).
- Your local branch and the remote branch have diverged!

### Step 1: Attempt to push and observe the error
```bash
cd repo
git push origin main
```
Observe the rejection: `[rejected] main -> main (fetch first)`.

### Step 2: Fetch and visualize the divergence
```bash
git fetch origin
git log --oneline --graph --all
```
Notice how `origin/main` and `main` have split from the initial commit.

### Step 3: Integrate remote changes
Integrate Alex's commit into your branch:
```bash
git pull --no-rebase origin main
```
*(If prompted for a commit message by your editor, save and exit. Git will automatically create the merge commit).*

### Step 4: Verify the combined history
```bash
git log --oneline --graph
ls
```
Notice:
- `tasks.txt` contains your changes.
- `notifications.txt` from Alex is now in your working tree.
- Your branch has incorporated both lines of work.

### Step 5: Push to the remote
Now that your branch contains all of `origin/main`'s history, the push will succeed:
```bash
git push origin main
```

### Step 6: Verify your mission
Run:
```bash
play check
```

---

## 6. Check Your Understanding

- [ ] Why does Git reject a non-fast-forward push? *(To prevent accidentally erasing someone else's commits from the remote).*
- [ ] What is the difference between `git fetch` and `git pull`? *(`fetch` only downloads commits without touching your working tree; `pull` fetches and merges/rebases into your active branch).*
- [ ] What does `git log --graph --all` show? *(A visual diagram of all branches, local and remote, and their relationship).*
- [ ] Why should you avoid `git push --force` on shared branches like `main`? *(It overwrites teammates' commits on the remote, causing data loss).*
