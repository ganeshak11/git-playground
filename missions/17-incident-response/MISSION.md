# Mission 17: Accidental Push to Main & Incident Response

## The Situation
It happens to almost every engineer at least once. 

You started hacking on an experimental payment gateway. In the zone of coding, you completely forgot to create a feature branch first. You committed your broken, half-baked code directly on `main` and typed `git push origin main`.

Within 90 seconds, alarms start ringing. Continuous Integration builds are failing. Teammates can't deploy. Production is blocked.

Your engineering manager reaches out calmly:
> *"Don't panic! In professional engineering, mistakes happen. We have a standard incident response playbook:
> 1. Don't lose your work: rescue your experimental code onto a proper feature branch.
> 2. Restore `main` immediately using a clean revert, and push it to `origin/main`.
> 3. Write a brief post-mortem report in `INCIDENT.md` so we can learn and configure branch protections."*

---

## 1. The Mental Model & Under-the-Hood Mechanics

### Order of Operations Matters!
If you rush to revert or reset `main` before saving your work, your experimental code will be removed from your working tree (forcing you to search through `git reflog` to recover it).

The professional sequence is:
1. **Pin your code with a new branch first:**
   ```bash
   git branch feature/payment-gateway
   ```
   Remember: a branch is just a 41-byte pointer! Creating this branch instantly points `feature/payment-gateway` at your WIP commit.
2. **Revert `main` safely:**
   Because `origin/main` is a public, shared branch, you must **never force-push reset**. Use `git revert` to append an inverse commit that removes `gateway.py`.
3. **Push `main`:**
   `origin/main` moves forward cleanly, removing the broken code from the production branch while preserving your feature branch intact!

```
INCIDENT RESPONSE VISUALIZATION:

STEP 1: BOTH MAIN AND REMOTE ARE CURRENTLY BROKEN
origin/main, main ───> [ C1: Initial Setup ] ───> [ C2: Broken WIP Gateway ] (HEAD)

STEP 2: PIN WORK WITH A FEATURE BRANCH POINTER
git branch feature/payment-gateway:
feature/payment-gateway ───────────────────────────────┐
origin/main, main       ───> [ C1: Initial Setup ] ───> [ C2: Broken WIP Gateway ] (HEAD)

STEP 3: REVERT MAIN AND PUSH
git revert HEAD && git push origin main:
feature/payment-gateway ───────────────────────────────> [ C2: Broken WIP Gateway ]
origin/main, main       ───> [ C1: Initial Setup ] ───> [ C2: Broken WIP Gateway ] ───> [ C3: Revert C2 ]

Outcome:
- main is completely healthy again.
- gateway.py is gone from main.
- feature/payment-gateway still has your complete WIP code ready for future development!
```

---

### The Blameless Post-Mortem (`INCIDENT.md`)
In high-performing engineering teams, post-mortems are **blameless**. We do not point fingers at individuals; we look at why the system permitted the mistake in the first place.

Your `INCIDENT.md` document should clearly state:
1. **What happened:** Accidental direct push of unfinished code to `main`.
2. **Remediation:** Rescued work to a feature branch, reverted `main`, and pushed the fix.
3. **Prevention:** Technical controls to prevent recurrence (e.g., enabling **GitHub Branch Protection Rules** requiring Pull Requests, reviews, and passing CI checks before merging).

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git branch <name>` | Creates a branch pointer at the current commit without switching to it |
| `git revert --no-edit HEAD` | Reverts the most recent commit on the current branch without opening editor |
| `git push origin main` | Pushes the clean revert commit to the remote |
| `git ls-tree -r <branch>` | Inspects files contained on a specific branch |

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Inspect the current damage
```bash
git log --oneline -2
ls -la
```
Notice `gateway.py` sits directly on `main` and is already pushed to `origin/main`.

### Step 3: Rescue your experimental code to a feature branch
Create a branch named `feature/payment-gateway` at the current commit:
```bash
git branch feature/payment-gateway
```
*(Your work is now securely pinned to this branch pointer!)*

### Step 4: Revert the bad commit on main
Ensure you are on `main` and revert the WIP commit:
```bash
git revert --no-edit HEAD
```

### Step 5: Push the fix to origin
Restore the health of the remote `origin/main`:
```bash
git push origin main
```

### Step 6: Verify the code separation
1. Check that `gateway.py` no longer exists on `main`:
   ```bash
   ls -la
   ```
2. Verify that `gateway.py` is safely preserved on `feature/payment-gateway`:
   ```bash
   git ls-tree -r feature/payment-gateway
   ```

### Step 7: Write the post-mortem in `INCIDENT.md`
Create `INCIDENT.md` in the repository root and document the event:
```markdown
# Incident Report: Accidental Direct Push to Main

## 1. What Happened
An engineer accidentally made a direct push to main with unfinished, broken code without opening a pull request.

## 2. Remediation
1. Created branch `feature/payment-gateway` to preserve the experimental code.
2. Reverted the broken commit on `main` using `git revert`.
3. Pushed the revert commit to `origin/main`.

## 3. Prevention
1. Enable GitHub branch protection rules on `main`.
2. Require all changes to go through Pull Requests with mandatory peer reviews and passing CI checks.
```

### Step 8: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] Why should you create the feature branch *before* running `git revert` on `main`?
- [ ] Why is `git revert` the correct fix for a broken public `main` rather than `git reset --hard`?
- [ ] What is a blameless post-mortem and why do teams write them?
- [ ] What GitHub feature physically prevents developers from accidentally pushing directly to `main`?
