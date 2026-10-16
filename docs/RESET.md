# "I Broke Something" — The Git Panic Manual

Take a breath. Almost nothing in Git is permanently lost unless you explicitly wipe your `.git` folder.

---

## 1. Did you break something in a Git Playground mission?

Just run:
```bash
play reset
```
This safely deletes only the current mission's sandbox and rebuilds it fresh from step 1.
Your progress on other completed missions is kept.

---

## 2. Uncommitted changes are messed up

### "I want to discard changes in a single file and go back to clean"
```bash
git restore <path/to/file>
```

### "I staged something by mistake and want to unstage it"
```bash
git restore --staged <path/to/file>
```

### "I want to discard ALL uncommitted changes everywhere"
```bash
git restore .
git clean -fd
```
*(Warning: `git clean -fd` deletes untracked files that git has never seen before).*

---

## 3. "I committed to the wrong branch!"

### If you haven't pushed yet:
1. Undo the commit without losing your work:
   ```bash
   git reset --soft HEAD~1
   ```
2. Switch to the branch you intended:
   ```bash
   git switch correct-branch
   ```
3. Commit your changes:
   ```bash
   git commit -m "Your commit message"
   ```

---

## 4. "I accidentally ran git reset --hard or deleted a branch!"

This is why `git reflog` exists.

1. View everywhere HEAD has been:
   ```bash
   git reflog
   ```
   You will see an output like:
   ```
   abc1234 HEAD@{0}: reset: moving to HEAD~1
   def5678 HEAD@{1}: commit: Important work done here
   ```
2. Find the hash from before the mistake (e.g. `def5678`).
3. Restore it onto a new branch:
   ```bash
   git switch -c recovery-branch def5678
   ```
Your commits are fully restored.

---

## 5. "I'm stuck in an editor and can't get out!"

- **If it's Nano:** Press `Ctrl + X`.
- **If it's Vim:** Press `Esc`, type `:q!` and press `Enter` (to discard) or `:wq` (to save).
- **If it's a pager (`less`):** Press `q`.
