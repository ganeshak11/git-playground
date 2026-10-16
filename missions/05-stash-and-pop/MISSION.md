# Mission 5: Stash and Pop

---

## 1. The Mental Model: The Developer's Clipboard

Picture this scenario:
You are in the middle of writing a new feature. You've modified two files and created a scratch notes file. The code is half-finished, untested, and doesn't even compile.

Suddenly, an alert rings out: **a critical bug is live in production!**
Your team needs a fix committed on `main` immediately.

You think: *"I'll just switch to `main` and fix it."*
But when you try `git switch main`, Git refuses:
```text
error: Your local changes to the following files would be overwritten by checkout:
    shop.py
Please commit your changes or stash them before you switch branches.
Aborting
```

You have a dilemma:
- **Option A:** Make a sloppy, broken commit on your feature branch (`"WIP broken code do not look"`). This pollutes your commit history with junk commits.
- **Option B:** Discard your work and redo it later. (Terrible idea!).
- **Option C (The Professional Way):** Use **`git stash`**.

---

## 2. What Is the Stash?

Think of the Git stash as a **temporary drawer or clipboard**:
- `git stash` sweeps all your uncommitted changes into a safe temporary holding area.
- It returns your working directory to a clean state matching your latest commit (`HEAD`).
- You are now free to switch branches, pull updates, or commit hotfixes.
- When you return, `git stash pop` pulls your unfinished changes right back out of the drawer!

```
[Working Directory: Dirty]  ---+
                               |  git stash
                               v
                         [The Stash Drawer]
                               ^
                               |  git stash pop
[Working Directory: Clean]  ---+
```

---

## 3. Essential Stash Commands

### 1. Stashing Changes
- `git stash`
  Stashes tracked modifications.
- `git stash -u` (or `git stash --include-untracked`)
  **Crucial command:** Stashes tracked modifications **AND** newly created untracked files. Without `-u`, new files you haven't run `git add` on yet are left behind in your working tree!
- `git stash push -m "description"`
  Gives your stash a descriptive name so you remember what it contains.

### 2. Inspecting Stashed Work
- `git stash list`
  Shows all stashed entries (e.g. `stash@{0}`, `stash@{1}`).
- `git stash show -p`
  Shows the actual diff inside the most recent stash.

### 3. Restoring Stashed Work
- `git stash pop`
  Applies the changes from `stash@{0}` back to your working directory **and removes it** from the stash list.
- `git stash apply`
  Applies the changes, but **keeps** the stash in the list (helpful if you want to apply the same stash to multiple branches).

### 4. Cleaning the Stash
- `git stash drop stash@{0}`
  Permanently deletes a specific stash entry.
- `git stash clear`
  Deletes all stash entries.

---

## 4. Your Mission Tasks

You are in a repository at `repo/` on branch `feature/discount`.
- You are halfway through implementing a coupon feature in `shop.py`.
- You also created an untracked scratchpad file: `discount_notes.txt`.
- A critical bug was found on `main`: the sales tax rate is wrong! It must be fixed from `0.08` to `0.05`.

Your goal is to stash your in-progress work, switch to `main`, apply and commit the hotfix, return to `feature/discount`, and pop your work back into place.

### Step 1: Inspect your in-progress work
```bash
cd repo
git status
git branch
```
Notice:
- You are on branch `feature/discount`.
- `shop.py` is modified.
- `discount_notes.txt` is untracked.

### Step 2: Stash your work (including untracked files!)
```bash
git stash -u -m "WIP coupon feature"
```
Check `git status` — your working tree is now completely clean!

### Step 3: Switch to `main`
```bash
git switch main
```

### Step 4: Fix the bug on `main`
In `shop.py`, change `TAX_RATE = 0.08` to `TAX_RATE = 0.05`.

Verify the fix with `git diff`:
```bash
git diff
```

Stage and commit the hotfix:
```bash
git add shop.py
git commit -m "Fix sales tax rate to 5%"
```

### Step 5: Switch back to your feature branch
```bash
git switch feature/discount
```

### Step 6: Restore your in-progress work
Pop your changes back out of the stash:
```bash
git stash pop
```

Run `git status` and `cat shop.py`:
- `shop.py` has your coupon feature code back!
- `discount_notes.txt` has been restored!
- Run `git stash list` — the stash list is empty!

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 5. Check Your Understanding

- [ ] What happens to untracked files if you run plain `git stash` without `-u`? *(They are left behind in your working directory).*
- [ ] What is the difference between `git stash pop` and `git stash apply`? *(`pop` restores and deletes the stash entry; `apply` restores while keeping the stash).*
- [ ] How can you see a list of all your stashed work? *(`git stash list`).*
- [ ] Does stashing create a new permanent commit in your branch history? *(No, it is a temporary holding area that keeps your history clean).*
