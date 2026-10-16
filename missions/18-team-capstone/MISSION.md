# Mission 18: Capstone Sprint: Full Team Collaboration

## The Situation
Congratulations on reaching the final mission!

Over the course of this playground, you've mastered Git's internal mental models:
- Bare remotes and folder mechanics
- Branch pointers and the Three Trees
- Merge conflict surgery
- Reflog time-travel recovery
- Interactive rebasing, squashing, and dropping
- Binary search debugging with `git bisect`
- Incident response and post-mortems

Now comes your **Capstone Sprint**. You will execute the exact end-to-end workflow used daily by high-performing engineering teams at top tech companies.

---

## 1. The Modern Team Collaboration Workflow

In a real engineering team:
1. You branch off `main` to build a feature (`feature/notifications`).
2. You commit your code and push the branch to `origin` to open a Pull Request.
3. While you were working, your teammate Alex finished another feature and merged it into `origin/main`.
4. Alex's changes modified `config.json`, which directly conflicts with your changes.
5. Your PR cannot be merged directly.
6. You must **rebase onto updated `main`**, **resolve the conflict**, **force-push your branch with lease**, and **merge into `main`** with a clean linear history!

```
THE FULL SPRINT CYCLE:

              ┌───> [You work: notifications.py + config.json] ───> Pushed to origin/feature
              │
Initial main ─┤
              │
              └───> [Alex merges: audit.py + config.json] ────────> Pushed to origin/main

YOUR TASK:
1. Pull Alex's changes into local main.
2. Rebase feature/notifications onto main.
3. Resolve the config.json conflict (keep both notifications and audit_logging).
4. Run git rebase --continue.
5. Update origin/feature with 'git push --force-with-lease'.
6. Fast-forward merge into main and push to origin/main!
```

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git switch main` | Switches to the main branch |
| `git pull origin main` | Fetches and fast-forwards local main to match remote |
| `git switch <branch>` | Switches to your feature branch |
| `git rebase main` | Replays feature branch commits on top of updated main |
| `git add <file>` | Stages the manually resolved conflict |
| `git rebase --continue` | Resumes rebase after staging conflict resolutions |
| `git push --force-with-lease` | Updates remote feature branch safely |
| `git merge --ff-only <branch>` | Integrates feature branch into main via clean fast-forward |

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Update your local `main` branch
Switch to `main` and pull teammate Alex's changes:
```bash
git switch main
git pull origin main
```
You will see Git fast-forward `main` and pull down `audit.py` and the updated `config.json`.

### Step 3: Rebase your feature branch onto `main`
Switch back to your feature branch and start the rebase:
```bash
git switch feature/notifications
git rebase main
```
Git will stop with a conflict notice:
```text
CONFLICT (content): Merge conflict in config.json
error: could not apply ... Add notifications feature and config
```

### Step 4: Resolve the conflict in `config.json`
Open `config.json` in your editor. You will see Git's conflict markers:
```json
<<<<<<< HEAD
      "task_management",
      "audit_logging"
=======
      "task_management",
      "notifications"
>>>>>>> Add notifications feature and config
```

Resolve the conflict so that the `features` list contains **all three features**:
```json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management",
    "audit_logging",
    "notifications"
  ]
}
```

### Step 5: Stage the resolution and continue the rebase
Tell Git the conflict is resolved and continue:
```bash
git add config.json
git rebase --continue
```
*(If your editor opens to confirm the commit message, save and close it)*.

### Step 6: Push your rebased feature branch to the remote
Update your remote branch using the safe lease flag:
```bash
git push --force-with-lease origin feature/notifications
```

### Step 7: Merge into `main` and publish
Now that your feature branch is completely rebased and conflict-free, merge it cleanly into `main` and push:
```bash
git switch main
git merge feature/notifications
git push origin main
```

### Step 8: Admire the clean linear history
Inspect the graph:
```bash
git log --graph --oneline
```
Notice how every feature from both you and your teammate sits in a straight, beautiful line with zero merge commits!

### Step 9: Verify your capstone completion
Run:
```bash
play check
```

---

## 4. Graduation Checklist: What You Can Now Explain
Having completed the Git Playground curriculum, you can confidently explain:
- [ ] Why a Git remote is simply another repository folder on a server or filesystem.
- [ ] Why a branch is merely a 41-byte text file storing a commit hash in `.git/refs/heads/`.
- [ ] The exact difference between the Working Tree, the Staging Index, and the Git Repository.
- [ ] How to diagnose and resolve merge conflicts with complete surgical confidence.
- [ ] How to rescue seemingly "lost" commits and deleted branches using `git reflog`.
- [ ] When to use `git reset` (local private branches) vs `git revert` (shared public branches).
- [ ] How to curate a clean PR history using interactive rebase (`squash` and `drop`).
- [ ] Why `--force-with-lease` is essential when pushing rebased branches to a team.
- [ ] How to track down regressions across hundreds of commits with `git bisect run`.
- [ ] How to handle accidental pushes to `main` with professional incident response playbooks.
