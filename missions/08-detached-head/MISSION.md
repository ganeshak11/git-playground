# Mission 8: Detached HEAD

---

## 1. The Mental Model: What Is "HEAD"?

Recall from Mission 1 that a branch is just a 41-byte text file storing a commit hash.
So what is **`HEAD`**?

`HEAD` is Git's compass — it tells Git **"Where am I right now?"**

You can see it with your own eyes by opening `.git/HEAD`:
```bash
cat .git/HEAD
```

### Normal State: Attached HEAD
In 99% of your daily work, `HEAD` points to a **branch pointer**:
```text
ref: refs/heads/main
```

When `HEAD` points to a branch, Git is in the **attached HEAD** state:

```
[Commit 1] <--- [Commit 2]
                     ^
                     |
                   [main]  <-- branch pointer
                     ^
                     |
                  [HEAD]   <-- "I am on main"
```

When you make a commit in this state:
1. Git creates `Commit 3`.
2. Git advances the `main` pointer to `Commit 3`.
3. `HEAD` remains attached to `main`.

---

## 2. The Detached HEAD State

What happens if you check out a specific **commit hash** (or tag) instead of a branch name?
```bash
git checkout a1b2c3d
```

Git prints a dramatic warning:
```text
You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches...
```

Now look at `.git/HEAD`:
Instead of `ref: refs/heads/...`, it contains the **raw 40-character commit hash**:
```text
a1b2c3d4e5f6...
```

`HEAD` is now pointing directly at a commit, completely detached from any branch:

```
[Commit 1] <--- [Commit 2]
     ^               ^
     |               |
   [HEAD]          [main]
 (Detached!)
```

### What happens if you commit while detached?
You can still commit! Git will create `Commit 3`, and `HEAD` will move to it:

```
[Commit 1] <--- [Commit 3: Prototype]
     ^                  ^
     |                  |
   [main]             [HEAD] (Detached!)
```

Notice:
- `HEAD` moved to `Commit 3`.
- But **no branch is tracking `Commit 3`**!
- If you switch back to `main` now (`git switch main`), `HEAD` jumps back to `main`. `Commit 3` is left behind with no branch pointing to it — an "orphan" commit!

---

## 3. The Rescue: Attaching a Branch

Rescuing an orphaned or detached commit is remarkably simple.
Since a branch is just a pointer, all you need to do is **give your commit a branch name**:

If you are currently on the detached commit:
```bash
git switch -c feature/my-idea
```
*(Or `git branch feature/my-idea`)*

Instantly, Git creates a new branch pointer pointing to your commit and attaches `HEAD` to it:

```
[Commit 1] <--- [Commit 3: Prototype]
     ^                  ^
     |                  |
   [main]     [feature/my-idea]
                        ^
                        |
                     [HEAD] (Attached!)
```

Your work is now safe, permanent, and part of the official branch graph!

---

## 4. Your Mission Tasks

You are in a repository at `repo/`.
Earlier, you checked out an older commit to test an experimental vectorization algorithm, and made a commit:
`"Prototype vectorized compute"`

You are currently standing in a **detached HEAD** state!
If you leave now without creating a branch, this prototype commit will be abandoned.

Your mission is to rescue this commit onto a new branch called `feature/vector-compute`, and then return to `main`.

### Step 1: Inspect the detached state
```bash
cd repo
git status
cat .git/HEAD
```
Notice:
- `git status` reports: `HEAD detached at ...`
- `.git/HEAD` contains a raw commit hash!

### Step 2: View the commit graph
```bash
git log --oneline --graph --all
```
Notice how `HEAD` is branching off the initial commit, floating without a branch name, while `main` sits on `"Expand compute metrics"`.

### Step 3: Attach a branch to rescue the commit
Create and switch to a new branch named `feature/vector-compute`:
```bash
git switch -c feature/vector-compute
```

Now check `.git/HEAD`:
```bash
cat .git/HEAD
```
It now says `ref: refs/heads/feature/vector-compute`! `HEAD` is officially attached.

### Step 4: Switch back to `main`
```bash
git switch main
```

### Step 5: Verify both branches are safe
```bash
git log --oneline --graph --all
```
Notice:
- Both `main` and `feature/vector-compute` are cleanly visible in your graph.
- Your prototype is safe and tracked by Git.

### Step 6: Verify your mission
Run:
```bash
play check
```

---

## 5. Check Your Understanding

- [ ] What does `.git/HEAD` contain in a normal "attached" state? *(A reference to a branch, e.g. `ref: refs/heads/main`).*
- [ ] What does `.git/HEAD` contain in a "detached" state? *(A raw 40-character commit hash).*
- [ ] Are commits made in a detached HEAD state immediately deleted when you switch branches? *(No, they remain in the repository and reflog, but have no branch pointing to them).*
- [ ] What command simultaneously creates a new branch and attaches `HEAD` to your current detached commit? *(`git switch -c <branch-name>`).*
