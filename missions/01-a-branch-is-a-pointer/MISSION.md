# Mission 1: A Branch Is Just a Pointer

---

## 1. The Mental Model: What Is a Branch?

Most beginners imagine a Git branch as a heavy, independent duplicate folder — like copying `my-project` to `my-project-copy`. Because of this mental image, developers often feel intimidated by branching, fearing that creating branches consumes disk space or complicates the repository.

### The Reality Under the Hood
In Git, **a branch is not a container of files, and it is not a copy of your project.**

A branch is literally just a **41-byte plain text file** stored inside the `.git/refs/heads/` directory. That file contains:
1. Exactly 40 hexadecimal characters representing a commit hash.
2. A single newline character (`\n`).

Total size on disk: **41 bytes**.

```
.git/
└── refs/
    └── heads/
        ├── main          <-- file containing commit hash "c333333..."
        ├── feature-v1    <-- file containing commit hash "b222222..."
        └── experimental  <-- file containing commit hash "a111111..."
```

---

## 2. How Git History and Pointers Work

Every Git commit contains a reference pointing back to its **parent commit**. This forms a chain of history:

```
[commit 1: a111111] <--- [commit 2: b222222] <--- [commit 3: c333333]
                                                        ^
                                                        |
                                                 main (branch pointer)
                                                        ^
                                                        |
                                                 HEAD (where you are)
```

- **`HEAD`** is a special pointer (stored in `.git/HEAD`) that points to the branch you currently have checked out: `ref: refs/heads/main`.
- **`main`** is a branch pointer pointing to `c333333`.

### What happens when you create a branch?
When you run:
```bash
git branch feature-v1 <commit-hash>
```
Git does **not** duplicate any files. Git simply writes a new 41-byte file called `.git/refs/heads/feature-v1` containing that commit's hash.

If you point `feature-v1` to `commit 2` and `experimental` to `commit 1`, your history looks like this:

```
[commit 1: a111111] <--- [commit 2: b222222] <--- [commit 3: c333333]
         ^                        ^                         ^
         |                        |                         |
    experimental              feature-v1                   main
                                                            ^
                                                            |
                                                           HEAD
```

### What happens when you commit?
When you make a new commit while on `main`:
1. Git creates a new commit object (`commit 4: d444444`) whose parent is `commit 3`.
2. Git updates the pointer `.git/refs/heads/main` to store `d444444`.
3. The other branch pointers (`feature-v1` and `experimental`) stay exactly where they were!

```
[commit 1] <--- [commit 2] <--- [commit 3] <--- [commit 4: d444444]
    ^                ^                                 ^
    |                |                                 |
experimental     feature-v1                           main (HEAD)
```

---

## 3. Useful Commands for This Mission

### Inspecting History
- `git log --oneline`
  Shows each commit on a single line with its abbreviated hash and message.
- `git log --oneline --graph --all`
  Shows a visual text graph of all branches and where their pointers are pointing.

### Referencing Past Commits
You can refer to commits by:
- Their exact hash (e.g. `d108de1` or `a1b2c3d...`).
- Relative syntax using `~`:
  - `HEAD` = current commit (Commit 3)
  - `HEAD~1` = parent of HEAD (Commit 2)
  - `HEAD~2` = grandparent of HEAD (Commit 1)

### Creating Branches
- `git branch <new-branch-name>`
  Creates a new branch pointing to the current commit (`HEAD`).
- `git branch <new-branch-name> <commit-hash-or-ref>`
  Creates a new branch pointing to **any past commit** in history without switching to it!

### Looking Under the Hood
You can view Git's internal pointers directly in your terminal:
- `ls -l .git/refs/heads/` (lists all local branch pointer files)
- `cat .git/refs/heads/main` (prints the exact commit hash that `main` points to)

---

## 4. Your Mission Tasks

You are in a workspace where a repository has already been created for you at `repo/` with 3 commits on `main`.

### Step 1: Enter the repo and inspect the history
```bash
cd repo
git log --oneline
```
Observe the 3 commits:
1. Root commit: `"Add basic project files"`
2. Middle commit: `"Implement task list feature"`
3. Latest commit (`HEAD`): `"Add task completion status"`

### Step 2: Create the `feature-v1` branch
Create a branch named `feature-v1` pointing to the **second commit** (`HEAD~1`):
```bash
git branch feature-v1 HEAD~1
```
*(You can also use the exact commit hash shown in `git log`).*

### Step 3: Create the `experimental` branch
Create a branch named `experimental` pointing to the **first commit** (`HEAD~2`):
```bash
git branch experimental HEAD~2
```

### Step 4: Advance `main` with a new commit
Make sure you are on branch `main` (`git status` or `git branch`).
Add release notes to `README.md` and commit:
```bash
echo "## Release Notes" >> README.md
git add README.md
git commit -m "Update documentation with release notes"
```

### Step 5: Verify the pointers for yourself!
Peek inside the `.git` folder to see the magic:
```bash
ls -l .git/refs/heads/
cat .git/refs/heads/main
cat .git/refs/heads/feature-v1
cat .git/refs/heads/experimental
```
Notice that:
- `main` has moved forward to your brand-new commit hash.
- `feature-v1` is still pointing to the second commit.
- `experimental` is still pointing to the first commit.

### Step 6: Verify your mission
Run:
```bash
play check
```

---

## 5. Check Your Understanding

Before moving to the next mission, you should be able to answer:
- [ ] If a repository has 1,000 branches, does it take up 1,000 times the disk space? *(No, just 41 bytes per branch pointer file!)*
- [ ] What is stored inside `.git/refs/heads/main`? *(A single 40-character commit hash + newline).*
- [ ] Can you create a branch that starts at an older commit from weeks ago? *(Yes: `git branch <name> <hash>`).*
- [ ] What does `HEAD` point to in normal usage? *(The active branch reference in `.git/refs/heads/`).*
