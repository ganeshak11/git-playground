# Mission 7: Cherry-Pick

---

## 1. The Mental Model: What Is Cherry-Picking?

In a team codebase, work happens simultaneously on dozens of feature branches.
Occasionally, a situation like this happens:

A teammate is working on a major, unfinished feature on a branch called `experiment/next-gen-ui`.
While testing, they notice and fix a **critical security vulnerability** in the database layer.

Now production has a problem:
- Production needs that security bugfix **immediately**.
- But the rest of `experiment/next-gen-ui` is half-finished, experimental code that would crash production if merged!

You can't run `git merge experiment/next-gen-ui` because that brings over **all** the commits on that branch.
You also don't want to copy-paste the fix manually into `main`, which loses the author's commit metadata and creates messy duplicate history.

The solution? **`git cherry-pick`**.

---

## 2. How Cherry-Pick Works

`git cherry-pick <commit-hash>` takes the **diff introduced by a single commit** from anywhere in the repository and applies it on top of your current branch as a brand-new commit.

```
main (before):
    [Initial Commit: C1] (HEAD)

experiment/next-gen-ui:
    [Initial Commit: C1] ---> [Commit A: Layout] ---> [Commit B: Security Fix] ---> [Commit C: 3D Canvas]


main (after git cherry-pick Commit-B):
    [Initial Commit: C1] ---------------------------> [Commit B': Security Fix] (HEAD)
```

Look at what happened:
1. Only the changes from **Commit B** were brought into `main`.
2. Commit A and Commit C were completely left behind on the experimental branch.
3. Commit B' is a new commit with the same message and diff, but a new parent (`C1`).
4. The `experiment/next-gen-ui` branch was not modified or damaged at all.

---

## 3. Useful Commands for This Mission

- `git log --oneline <branch-name>`
  Shows the commit history of another branch without switching to it!
  Example: `git log --oneline experiment/next-gen-ui`

- `git cherry-pick <commit-hash>`
  Applies that specific commit onto your current `HEAD` and automatically creates a new commit with the original message and author.

- `git show <commit-hash>`
  Inspects the contents and diff of any commit to be sure it's the one you want.

- `git cherry-pick --abort`
  The safety button: if you ever run into a messy conflict during a cherry-pick, this cancels it and returns your branch to normal.

---

## 4. Your Mission Tasks

You are in a repository at `repo/` on branch `main`.
There is an experimental branch called `experiment/next-gen-ui`.
That branch contains 3 commits:
1. `"Experimental layout redesign"`
2. `"Fix critical SQL injection vulnerability in db.py"` (Security fix)
3. `"WIP unfinished 3D animations"`

Your mission is to cherry-pick **only** the SQL injection fix into `main`.

### Step 1: Inspect the experimental branch
Make sure you are on `main` (`git branch`).
Inspect the commits on `experiment/next-gen-ui`:
```bash
cd repo
git log --oneline experiment/next-gen-ui
```
Find the commit hash for:
`Fix critical SQL injection vulnerability in db.py`

### Step 2: Inspect the fix before picking
View the diff of that commit:
```bash
git show <bugfix-commit-hash>
```
Notice: it modifies `db.py` to sanitize SQL inputs.

### Step 3: Cherry-pick the fix onto `main`
Make sure you are on `main`:
```bash
git cherry-pick <bugfix-commit-hash>
```

### Step 4: Verify the outcome
Run:
```bash
git log --oneline
```
Notice:
- `main` now has the security fix as its latest commit!
- Run `cat db.py` — the SQL injection fix is in place.
- Run `cat ui.py` — notice the UI is still the original standard UI. The experimental layout and 3D code were **not** merged!

### Step 5: Verify your mission
Run:
```bash
play check
```

---

## 5. Check Your Understanding

- [ ] Does `git cherry-pick` delete the commit from the original branch? *(No, the original branch remains unchanged).*
- [ ] Does the cherry-picked commit on `main` have the exact same commit hash as the original commit? *(No, it has a different parent, so its hash is different).*
- [ ] What is the difference between `git merge <branch>` and `git cherry-pick <commit>`? *(`merge` brings all commits from that branch; `cherry-pick` copies only one specific commit).*
- [ ] How can you inspect the commits of another branch without checking it out? *(`git log <branch-name>`).*
