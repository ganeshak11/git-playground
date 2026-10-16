# Mission 6: Undo the Last Commit

---

## 1. The Mental Model: What Does `git reset` Actually Do?

You just typed `git commit`, and immediate regret sets in:
- You had a typo in the commit message.
- You forgot to include a file.
- You accidentally committed unfinished debug code.

You search how to undo a commit, and you are greeted with three options:
`git reset --soft`
`git reset --mixed`
`git reset --hard`

Many developers fear `git reset` because they think it deletes their work.
To conquer this fear, remember the **Three Areas of Git** from Mission 2:

```
[Working Directory] <--- git add ---> [Staging Area] <--- git commit ---> [Repository (HEAD)]
```

When you run `git reset HEAD~1` (move 1 commit back in history):
**All three modes move the branch pointer (`HEAD`) backwards by one commit.**
The *only* difference between them is what happens to your Staging Area and your Working Directory:

| Reset Flag | Moves `HEAD`? | Keeps Staging Area? | Keeps Working Files? | Danger Level |
|---|---|---|---|---|
| **`--soft`** | YES (steps back) | **YES** (Files remain staged!) | **YES** | Safe & Gentle |
| **`--mixed`** (default) | YES (steps back) | **NO** (Unstages files) | **YES** (Files remain on disk!) | Safe & Common |
| **`--hard`** | YES (steps back) | **NO** (Wipes staging) | **NO** (Discards disk edits!) | **Destructive** |

---

## 2. When to Use Each Flag

### 1. `git reset --soft HEAD~1` — "I want to redo the commit"
- It undoes the commit, but keeps all the changes in your **Staging Area**.
- When you run `git status`, all your files are still green (**"Changes to be committed"**).
- **Use case:** You committed too soon, want to change the message, or want to add one more file before re-committing.

### 2. `git reset --mixed HEAD~1` (or simply `git reset HEAD~1`) — "I want to re-examine my changes"
- This is Git's default behavior.
- It undoes the commit AND unstages the files, but **leaves your files on disk untouched**.
- When you run `git status`, your files are red (**"Changes not staged for commit"**).
- **Use case:** You staged the wrong combination of files and want to use `git diff` and `git add` to restage carefully.

### 3. `git reset --hard HEAD~1` — "Throw it all away"
- It moves HEAD back AND discards all modifications from both staging and disk.
- **Use case:** The entire commit was an experiment that failed, and you want to erase it completely.
- **Warning:** Any uncommitted changes on disk are permanently lost!

---

## 3. Your Mission Tasks

You are in a repository at `repo/`.
A sloppy commit was just made to `main` with the commit message `"temp stuff whatever"`.
In that commit:
- `payment.py` has a good feature (`process_stripe_payment`), but ALSO has an accidental broken line: `# DRAFT BROKEN: send_email_receipt_v2()`.
- `settings.py` was mistakenly changed to `DEBUG = True` (it should be `DEBUG = False` in production).

Your goal is to use `git reset --soft HEAD~1` to undo the commit, fix the code, and commit a clean version.

### Step 1: Inspect the sloppy commit
```bash
cd repo
git log -1 --stat
git show
```
Notice:
- The commit message is `"temp stuff whatever"`.
- It modified `payment.py` and `settings.py`.

### Step 2: Undo the commit with `--soft`
```bash
git reset --soft HEAD~1
```
Now run:
```bash
git status
```
Notice the magic:
- The sloppy commit is gone from history!
- Both `payment.py` and `settings.py` are **still in your staging area** (green), ready for you to adjust.

### Step 3: Fix the code
1. In `payment.py`: Remove the broken line `# DRAFT BROKEN: send_email_receipt_v2()`. Keep `process_stripe_payment`.
2. In `settings.py`: Change `DEBUG = True` to `DEBUG = False`.

### Step 4: Stage the corrected files
```bash
git add payment.py settings.py
```

Check your diff before committing:
```bash
git diff --staged
```

### Step 5: Make a clean commit
```bash
git commit -m "Implement Stripe payment processing and configure production settings"
```

### Step 6: Verify the history
```bash
git log --oneline
```
Notice:
- There are exactly 2 commits on `main`.
- The `"temp stuff whatever"` commit is gone.
- The new, clean commit sits cleanly on top of the initial commit.

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding

- [ ] What happens to your files on disk when you run `git reset --soft HEAD~1`? *(Nothing! They remain on disk and stay staged in the staging area).*
- [ ] What is the default reset mode if you don't specify any flags? *(`--mixed`).*
- [ ] Which reset flag permanently overwrites uncommitted changes in your working directory? *(`--hard`).*
- [ ] If you run `git reset --soft HEAD~1`, does `git log` still show the undone commit on that branch? *(No, the branch pointer moved back to the parent commit).*
