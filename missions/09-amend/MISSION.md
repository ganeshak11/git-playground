# Mission 9: Amend a Commit

---

## 1. The Mental Model: The Polish Tool

You just pressed `Enter` on `git commit`, and immediate embarrassment strikes:
1. There's a glaring typo in the message: `"Add biometirc auth support"`.
2. You look at `git status` and realize you **forgot to include a critical file** (`test_auth.py`)!

### The Amateur Approach vs. The Professional Approach
Beginners often create a messy trail of corrective commits:
```text
* 3a1f9e2 fix typo in commit message
* c4b2d18 oops forgot test file
* a8127f0 Add biometirc auth support
```
This clutters the project history and looks unprofessional in pull requests.

The professional tool for this job is **`git commit --amend`**.

---

## 2. How `--amend` Works Under the Hood

In Git, **commits are cryptographically immutable**. You cannot literally reach inside a commit object and change its text or files.

Instead, `git commit --amend` does something brilliant:
1. It looks at your **Staging Area** (anything newly staged with `git add`).
2. It looks at the **parent** of your current commit.
3. It creates a **brand-new replacement commit** that combines the previous commit's changes with your newly staged files, and lets you update the message.
4. It swaps `HEAD` to point to this new commit, discarding the imperfect one!

```
Before amend:
[Initial Commit] <--- [Commit A: Has typo, missing test file] (HEAD)

After git commit --amend:
[Initial Commit] <--- [Commit A': Fixed message, includes test file] (HEAD)
       \
        +--- [Commit A: Abandoned]
```

Result: Your repository looks as though you got it 100% right on the very first try!

---

## 3. Two Common Ways to Use `--amend`

### 1. Fixing the message only
If you just want to fix a typo in the most recent commit message without touching files:
```bash
git commit --amend -m "Corrected commit message"
```

### 2. Adding a forgotten file
If you forgot to stage a file:
```bash
git add forgotten_file.py
git commit --amend --no-edit
```
*(`--no-edit` tells Git: "Fold the staged changes into the commit, but keep the existing message").*

Or you can update both the files **and** the message in one shot:
```bash
git add forgotten_file.py
git commit --amend -m "Add feature and unit tests"
```

---

## 4. The Golden Rule of Amending

> **Only amend commits that have NOT been pushed to a shared remote.**

Because `--amend` generates a brand-new commit hash, amending a commit that your teammates have already pulled will rewrite history and cause non-fast-forward push rejections.
For local, unpushed commits, however, `--amend` is the cleanest tool in Git!

---

## 5. Your Mission Tasks

You are in a repository at `repo/` on branch `main`.
You just made a commit:
- The message has a typo: `"Add biometirc auth support"`.
- You forgot to include `test_auth.py`, which is sitting untracked in your working tree!

Your goal is to use `git commit --amend` to produce a single clean commit that includes `test_auth.py` and fixes the typo in the message.

### Step 1: Inspect the current state
```bash
cd repo
git log -1
git status
```
Notice:
- `git log -1` shows the typo: `biometirc`.
- `git status` shows `test_auth.py` was left untracked.

### Step 2: Stage the forgotten file
```bash
git add test_auth.py
```
Check `git status` — `test_auth.py` is now in your Staging Area.

### Step 3: Amend the commit
Run `git commit --amend` with the corrected message:
```bash
git commit --amend -m "Add biometric auth support and unit tests"
```

### Step 4: Verify the result
Run:
```bash
git log --oneline
```
Notice:
- There are **only 2 commits** in the entire history!
- The typo is gone.
- Run `git show --stat` — both `auth.py` and `test_auth.py` belong to this single commit.
- Run `git status` — the working tree is completely clean.

### Step 5: Verify your mission
Run:
```bash
play check
```

---

## 6. Check Your Understanding

- [ ] Does `git commit --amend` modify an existing commit or create a new one? *(It creates a brand new replacement commit with a new hash).*
- [ ] What flag keeps the existing commit message unchanged while adding new files? *(`--no-edit`).*
- [ ] Why should you avoid amending commits that have already been pushed to a shared branch? *(Because it rewrites history, causing push rejections and divergence for teammates).*
- [ ] If you amend a commit, how many commits are added to your branch history? *(Zero net commits; the old one is replaced by the new one).*
