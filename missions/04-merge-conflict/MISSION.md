# Mission 4: Merge Conflict

---

## 1. The Mental Model: Why Conflicts Happen

A **merge conflict** is the number-one source of fear and frustration for Git beginners.
When a conflict occurs, Git halts with a scary-sounding message:

```text
Auto-merging app.py
CONFLICT (content): Merge conflict in app.py
Automatic merge failed; fix conflicts and then commit the result.
```

Take a breath. **A merge conflict is not an error, and nothing is broken.**
A conflict is just Git being responsible.

### When Does Git Merge Automatically?
Git is remarkably smart. If you and a teammate:
- Edit **different files**: Git merges automatically.
- Edit **different lines** of the same file: Git merges automatically.

### When Does Git Stop with a Conflict?
Git only stops when you and a teammate change the **exact same lines** in the same file.
Git cannot read human minds. It doesn't know whether your version is right, your teammate's version is right, or if both should be combined. So Git pauses, inserts **conflict markers** into the file, and asks you — the human — to make the decision.

---

## 2. Anatomy of Conflict Markers

When a conflict occurs, Git modifies the conflicted file directly, wrapping the contested code between markers:

```python
<<<<<<< HEAD
MAX_ITEMS_PER_PAGE = 50
=======
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets
>>>>>>> c49d8e20b3... (or origin/main)
```

Look closely at the three marker lines:
1. **`<<<<<<< HEAD`**: Marks the beginning of **your version** (what was already on your local branch).
2. **`=======`**: The divider separating your version from the incoming version.
3. **`>>>>>>> <commit-or-branch>`**: Marks the end of the **incoming version** (from the branch or remote you are merging).

---

## 3. The 4-Step Resolution Recipe

Resolving a conflict is straightforward once you know the recipe:

### Step 1: Open the file and decide the outcome
Look at both versions. You have three choices:
- Keep your version.
- Keep their version.
- Combine parts of both.

### Step 2: Delete ALL conflict markers
Remove the `<<<<<<< HEAD`, `=======`, and `>>>>>>> ...` lines completely.
Your final file should look like clean, normal code:
```python
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets
```

### Step 3: Tell Git you are done (`git add`)
Staging the file tells Git: *"I have reviewed and resolved this conflict!"*
```bash
git add app.py
```
Notice in `git status`: the file moves from **"Unmerged paths"** to **"Changes to be committed"**.

### Step 4: Finalize the merge (`git commit`)
```bash
git commit
```
Git creates the merge commit. You can accept the default message or provide your own with `-m`.

---

## 4. The Panic Button: `git merge --abort`

If you ever feel lost during a merge conflict and want to start over:
```bash
git merge --abort
```
This safely rolls your repository back to the exact state it was in before you started the merge. No files are lost or damaged.

---

## 5. Your Mission Tasks

You are in a repository at `repo/`.
- Both you and your teammate Jordan changed the pagination limit in `app.py`.
- You set `MAX_ITEMS_PER_PAGE = 50`.
- Jordan already pushed `MAX_ITEMS_PER_PAGE = 100` to `origin/main`.

### Step 1: Pull from the remote and trigger the conflict
```bash
cd repo
git pull origin main
```
Observe Git's message:
`CONFLICT (content): Merge conflict in app.py`

### Step 2: Inspect the conflict state
Run:
```bash
git status
```
Notice `app.py` is listed under `both modified`.

Open `app.py` in your terminal or editor (e.g. `cat app.py`) to see the conflict markers (`<<<<<<< HEAD`, `=======`, `>>>>>>>`).

### Step 3: Resolve the conflict
You and Jordan discussed the issue in Slack and agreed to use Jordan's value of `100` with their comment.

Edit `app.py` so that line becomes:
```python
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets
```
**CRITICAL:** Ensure all marker lines (`<<<<<<<`, `=======`, `>>>>>>>`) are completely removed!

### Step 4: Mark the conflict as resolved
```bash
git add app.py
git status
```
Notice `app.py` is now staged for commit.

### Step 5: Finalize the merge and push
```bash
git commit -m "Resolve pagination conflict by setting limit to 100"
git push origin main
```

### Step 6: Verify your mission
Run:
```bash
play check
```

---

## 6. Check Your Understanding

- [ ] Does Git create a conflict when two developers edit different files? *(No, it auto-merges).*
- [ ] What does `<<<<<<< HEAD` mean in a conflict? *(The beginning of the changes on your current local branch).*
- [ ] What command tells Git that you have finished resolving a conflicted file? *(`git add <filename>`).*
- [ ] How can you cancel an active merge and go back to a clean state? *(`git merge --abort`).*
