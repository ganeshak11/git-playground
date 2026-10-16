# Mission 12 Hints: Revert a Pushed Bad Commit

### Hint 1: The Concept (Why not reset?)
When commits have already been pushed to a shared remote like `origin/main`, running `git reset` is dangerous because it rewrites history. It rewinds your local pointer, leaving your branch behind the remote and orphaning any commits made after it. If forced to the remote, it breaks history for every teammate.

Instead, Git provides a safe, forward-moving undo command that computes the exact opposite of a commit and creates a new commit containing that inverse change. What command is that?

---

### Hint 2: Inspecting and Reverting
1. Look at the log to find the hash of the commit that added the surcharge fee:
   ```bash
   git log --oneline
   ```
2. Note the commit hash for `"Add premium surcharge fee"` (it will be two commits behind HEAD).
3. Use `git revert <hash>` to create a new commit that undoes only that commit's changes.
4. Finally, push the new commit to `origin/main`.

---

### Hint 3: Exact Solution
From inside your `repo/` directory:

1. View history and grab the bad commit's hash:
   ```bash
   git log --oneline
   ```
   Look for the commit titled `Add premium surcharge fee`.

2. Revert that specific commit:
   ```bash
   git revert --no-edit <bad-commit-hash>
   ```
   *(Or run `git revert <bad-commit-hash>` and save & exit your editor).*

3. Push the new revert commit to the remote:
   ```bash
   git push origin main
   ```

4. Verify your work:
   ```bash
   play check
   ```
