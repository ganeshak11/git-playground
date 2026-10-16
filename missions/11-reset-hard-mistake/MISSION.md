# Mission 11: Undoing an Accidental `reset --hard`

---

## 1. The Nightmare Scenario

You intended to discard a small change, but typed the wrong command:

```bash
git reset --hard HEAD~2
HEAD is now at 3b1e8f2 Initial crypto service setup
```

Your heart stops:
- Two major commits completely vanished from `git log`.
- The files and functions you wrote over the last two days vanished from your disk.
- `git status` says `"nothing to commit, working tree clean"`.
- It looks like your work was completely vaporized.

Many developers believe `git reset --hard` is the point of no return.
**It is not. Your commits are still alive.**

---

## 2. The Mental Model: Why Reset Doesn't Destroy Commits

In Git, **commits are immutable objects stored in Git's object database.**

When you ran `git reset --hard HEAD~2`:
1. Git moved the `main` pointer backwards by two commits.
2. Git updated your working files to match that older commit.
3. **Git did NOT delete the two newer commits.**

The newer commits are simply "unreachable" by ordinary `git log` because no branch is currently pointing to them.

And how does Git remember where your branch was 10 seconds ago?
**`git reflog`!**

---

## 3. Using Reflog to Rewind Time

Every time you run a command that moves `HEAD`, Git writes an entry into the reflog.
If you run `git reflog`, you will see:

```text
3b1e8f2 HEAD@{0}: reset: moving to HEAD~2
f9e8d7c HEAD@{1}: commit: Implement end-to-end payload encryption
b6a5c4d HEAD@{2}: commit: Add cryptographic keypair generation
```

Look closely at this output:
- `HEAD@{0}` is where you are **right now** (at the old commit `3b1e8f2` after the reset).
- `HEAD@{1}` is where `HEAD` was **immediately before the reset ran**: commit `f9e8d7c`!

That means commit `f9e8d7c` still exists, and it contains all of your code!

---

## 4. The Undo Command

How do you undo an accidental `reset --hard`?
**By running `reset --hard` forward to where you were!**

```bash
git reset --hard <commit-hash>
```
*(Or even simpler: `git reset --hard HEAD@{1}`)*

When you run this:
1. Git moves `main` forward to `f9e8d7c`.
2. Git restores your working files to match that commit.
3. Both commits reappear in `git log`!
4. It is as if the mistake never happened.

---

## 5. Your Mission Tasks

You are in a repository at `repo/` on branch `main`.
Someone accidentally ran `git reset --hard HEAD~2`, rewinding `main` back to the initial setup and wiping two encryption feature commits from disk!

Your goal is to use `git reflog` to find the lost commit and restore `main` to its full history.

### Step 1: Witness the damage
```bash
cd repo
git log --oneline
cat crypto.py
```
Notice:
- `git log` only shows `"Initial crypto service setup"`.
- `crypto.py` is missing all the keypair generation and encryption code!

### Step 2: Open the reflog
```bash
git reflog
```
Look for:
`HEAD@{0}: reset: moving to HEAD~2`
Right below it, find:
`HEAD@{1}: commit: Implement end-to-end payload encryption`

Note its 7-character commit hash (e.g. `f9e8d7c`).

### Step 3: Undo the reset
Run `git reset --hard` to move `main` back forward:
```bash
git reset --hard <commit-hash>
```
*(You can also use: `git reset --hard HEAD@{1}`)*

### Step 4: Verify the full recovery
```bash
git log --oneline
cat crypto.py
```
Notice:
- All 3 commits are back in history:
  1. `"Initial crypto service setup"`
  2. `"Add cryptographic keypair generation"`
  3. `"Implement end-to-end payload encryption"`
- `crypto.py` has all functions restored!
- `git status` is clean.

### Step 5: Verify your mission
Run:
```bash
play check
```

---

## 6. Check Your Understanding

- [ ] Does `git reset --hard` permanently erase committed snapshots from the Git database? *(No, commits remain stored and reachable via reflog).*
- [ ] What does `HEAD@{1}` mean in `git reflog`? *(Where HEAD was pointing 1 action ago).*
- [ ] How do you undo a `git reset --hard`? *(By running `git reset --hard` to the commit hash from before the reset).*
- [ ] What is the one thing that `git reset --hard` CAN permanently destroy? *(Uncommitted changes that were never added or committed anywhere! Always stash before resetting).*
