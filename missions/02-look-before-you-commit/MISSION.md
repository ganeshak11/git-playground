# Mission 2: Look Before You Commit

---

## 1. The Mental Model: The Three Areas of Git

In simple tools, saving a file immediately saves it to history.
Git does not work like that. Git has **three distinct areas**:

```
+-------------------+      git add       +-------------------+     git commit     +-------------------+
| Working Directory | -----------------> |   Staging Area    | -----------------> |    Repository     |
|   (Your Files)    |                    |      (Index)      |                    |      (HEAD)       |
+-------------------+ <----------------- +-------------------+                    +-------------------+
                         git restore
```

1. **Working Directory (Your Files)**: The actual files on your filesystem where you write code, test scripts, and generate logs.
2. **Staging Area (Index)**: The preparation room. A preview of what your **next commit** will look like. Nothing enters a commit unless it has been staged here.
3. **Repository (HEAD)**: The permanent history of snapshots already recorded into Git.

### Why does the Staging Area exist?
Beginners often wonder: *"Why can't I just commit my working files directly?"*
The staging area gives you the power to be **intentional**:
- You can work on three different files, but commit only one of them.
- You can leave temporary debug prints or experimental scripts unstaged while cleanly committing production features.
- You can craft small, atomic commits that tell a clear story.

---

## 2. The Danger of `git add .`

The most common beginner habit is typing:
```bash
git add .
git commit -m "update"
```

**Never do this blindly.**
In professional development, `git add .` causes massive headaches:
- **Leaked Secrets**: Developers accidentally commit `.env` files with production API keys, AWS tokens, or database passwords. Once committed, secrets are stored in Git history forever — even if you delete the file in the next commit!
- **Junk Files**: Huge build artifacts (`node_modules/`, `*.log`, `.DS_Store`, `build/`) bloat the repository and cause conflicts.
- **Unfinished Debug Code**: `console.log("TESTING HERE 123")` or hardcoded test bypasses get shipped straight to production.

Professional developers follow a golden rule:
> **Always inspect your diffs before committing.**

---

## 3. The Inspection Toolkit

Git provides tools to look at your changes at every stage:

### 1. `git status` — The Bird's-Eye View
Tells you which files are:
- **Untracked**: Git doesn't know about them yet.
- **Modified (unstaged)**: Changed in your working directory, but not added to the staging area.
- **Changes to be committed (staged)**: Ready to be frozen into the next commit.

### 2. `git diff` — Working Tree vs. Staging Area
Shows exactly what lines you changed in your working tree that have **not yet been staged**:
```bash
git diff
```

### 3. `git diff --staged` (or `git diff --cached`) — Staging Area vs. HEAD
Shows the exact changes that are currently staged and **will be included in your next commit**:
```bash
git diff --staged
```
*Tip: If `git diff --staged` shows something you didn't mean to commit, unstage it with `git restore --staged <file>`.*

---

## 4. Keeping Secrets Out with `.gitignore`

A `.gitignore` file tells Git which files or patterns to completely ignore.
Files matching `.gitignore`:
- Never appear in `git status` under "Untracked files".
- Cannot be accidentally staged with `git add .`.

### Basic `.gitignore` Syntax:
```gitignore
# Ignore a specific file
.env

# Ignore all files ending in .log
*.log

# Ignore a directory and everything inside it
node_modules/
dist/

# Exception: don't ignore this specific log
!important.log
```

You can test if a file is being correctly ignored using:
```bash
git check-ignore -v .env
```
*(Git will tell you which line of `.gitignore` is ignoring the file).*

---

## 5. Your Mission Tasks

You are in a workspace where a web service repository exists at `repo/`.
A previous developer left behind a messy state:
- `.env` contains a private secret token (`API_SECRET_KEY`).
- `debug.log` contains temporary test logs.
- `config.js` has a legitimate configuration addition (`TIMEOUT: 5000`).
- `server.js` has a clean `/health` endpoint, but ALSO has a messy debug line (`console.log("DEBUG: ...")`).

Your mission is to clean up, ignore the noise, discard the debug code, and commit only the production changes.

### Step 1: Inspect the mess
```bash
cd repo
git status
git diff
```
Notice:
- `config.js` and `server.js` are modified.
- `.env` and `debug.log` are untracked.
- In `server.js`, look at the `DEBUG:` log line.

### Step 2: Create a `.gitignore`
Create a `.gitignore` in `repo/` that ignores:
1. `.env`
2. `*.log`

```bash
cat << 'EOF' > .gitignore
.env
*.log
EOF
```

Check `git status` again. Notice that `.env` and `debug.log` have vanished from the untracked list, and `.gitignore` appeared!

### Step 3: Remove the debug print from `server.js`
Open `server.js` in your editor (or edit it) and remove the line containing `DEBUG: Incoming request`.
Keep the `/health` endpoint intact!

Run `git diff server.js` to verify: only the `/health` endpoint changes should remain.

### Step 4: Stage the clean changes
Stage `.gitignore`, `config.js`, and `server.js`:
```bash
git add .gitignore config.js server.js
```

### Step 5: Verify what you are about to commit
Run:
```bash
git diff --staged
```
Verify that:
- You see the `.gitignore` rules.
- You see `TIMEOUT: 5000` in `config.js`.
- You see the `/health` check in `server.js`.
- There are NO debug logs and NO `.env` secrets.

### Step 6: Commit and verify
```bash
git commit -m "Add health check endpoint, update config, and add gitignore"
```

Check that your working tree is clean:
```bash
git status
```
*(Notice: `.env` and `debug.log` still exist locally on disk, but Git happily ignores them!)*

### Step 7: Run the check
```bash
play check
```

---

## 6. Check Your Understanding

- [ ] What is the difference between `git diff` and `git diff --staged`?
- [ ] If you commit a secret file and then run `git rm secret.txt` in the next commit, is the secret gone? *(No! It stays in the history of the previous commit forever).*
- [ ] What happens to untracked files on disk when they are added to `.gitignore`? *(They stay on disk safely, but Git stops tracking or suggesting them).*
- [ ] What Git command checks which `.gitignore` rule is ignoring a file? *(`git check-ignore -v <filename>`).*
