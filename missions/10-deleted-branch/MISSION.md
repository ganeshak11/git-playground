# Mission 10: Rescuing a Deleted Branch

---

## 1. The Mental Model: Where Do Deleted Branches Go?

You run `git branch -D feature/search-indexing`, and horror washes over you.
You realize that was the branch containing three days of intense work that hadn't been pushed to GitHub yet!

```text
Deleted branch feature/search-indexing (was 7a3b4c5).
```

Did you just delete all your code?
**NO! Absolutely not.**

### Remember: A Branch Is Just a 41-Byte File
In Mission 1, you learned that a branch is literally just a 41-byte text file inside `.git/refs/heads/`.
When you delete a branch, Git deletes that 41-byte file.
**Git does NOT delete the commit objects.**

The commits (`7a3b4c5`, its parents, the files, the trees) are still sitting completely intact inside Git's object database.
The only problem is that without a branch pointer pointing to them, they no longer show up in `git branch` or `git log`.

To bring the branch back, you only need to answer one question:
**"What was the commit hash of that branch before it was deleted?"**

---

## 2. Meet Git's Time Machine: `git reflog`

Every local Git repository has a personal, chronological diary called the **reflog** (Reference Log).
Every time `HEAD` moves (when you commit, checkout, switch, rebase, or reset), Git records the exact commit hash and a brief reason.

Even if you delete a branch, the commits you made on that branch remain in the reflog for 30 to 90 days!

Run:
```bash
git reflog
```

You will see output like this:
```text
4c1a2b3 HEAD@{0}: checkout: moving from feature/search-indexing to main
7a3b4c5 HEAD@{1}: commit: Implement inverted index search algorithm
9f2d1e0 HEAD@{2}: commit: Add tokenizer module
3b1e8f2 HEAD@{3}: checkout: moving from main to feature/search-indexing
```

Look at `HEAD@{1}`:
Right before you switched back to `main`, `HEAD` was at commit `7a3b4c5`, titled `"Implement inverted index search algorithm"`.
**That was the tip of your deleted branch!**

---

## 3. How to Resurrect the Branch

Once you have the commit hash from `git reflog`, restoring the entire branch is as simple as re-creating the branch pointer at that commit:

```bash
git branch <branch-name> <commit-hash>
```

Example:
```bash
git branch feature/search-indexing 7a3b4c5
```

Instantly:
- The branch is recreated.
- All commits leading up to that hash are reconnected.
- All files, diffs, and history are 100% restored.

---

## 4. Your Mission Tasks

You are in a repository at `repo/` on branch `main`.
A feature branch called `feature/search-indexing` was accidentally deleted!
It contained an implementation of an inverted index search algorithm and a tokenizer module.

Your goal is to use `git reflog` to locate the deleted branch's tip and resurrect `feature/search-indexing`.

### Step 1: Confirm the branch is missing
```bash
cd repo
git branch
```
Notice: only `main` is listed.

### Step 2: Open the reflog
```bash
git reflog
```
Scan through the entries and find the commit:
`Implement inverted index search algorithm`

Copy its commit hash (the 7-character code on the left, e.g. `7a3b4c5`).

### Step 3: Resurrect the branch
Recreate `feature/search-indexing` pointing to that commit:
```bash
git branch feature/search-indexing <commit-hash>
```

### Step 4: Verify the resurrection
Check your branches:
```bash
git branch
```
`feature/search-indexing` is back!

Inspect the recovered branch's history:
```bash
git log --oneline feature/search-indexing
```
Notice: both `"Implement inverted index search algorithm"` and `"Add tokenizer module"` are completely intact!

Check the files on that branch:
```bash
git show feature/search-indexing:search.py
git show feature/search-indexing:tokenizer.py
```
All code is fully recovered.

### Step 5: Verify your mission
Make sure you are on `main` (`git branch`), then run:
```bash
play check
```

---

## 5. Check Your Understanding

- [ ] Does `git branch -D` delete your source code files from Git's object database? *(No, it only deletes the 41-byte branch pointer).*
- [ ] What is `git reflog`? *(A local chronological audit log of everywhere HEAD has moved on your machine).*
- [ ] How long does Git retain commits in the reflog before garbage collection? *(Usually 30 to 90 days).*
- [ ] What command resurrects a branch from a commit hash found in the reflog? *(`git branch <branch-name> <commit-hash>`).*
