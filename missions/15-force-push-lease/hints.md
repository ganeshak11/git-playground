# Mission 15 Hints: Force-Push After Rebase (--force-with-lease)

### Hint 1: Why was 'git push' rejected?
When you amended or rebased your local branch, Git generated a new commit SHA. Because the remote branch (`origin/feature/export-csv`) points to your old commit SHA, Git detects that the push is **non-fast-forward**. Git will refuse to overwrite it by default to protect against data loss.

---

### Hint 2: The Right Flag
Normally, developers are tempted to reach for `git push --force` (or `-f`), but `--force` blindly overwrites the remote even if a teammate pushed commits while you were working!

Instead, Git provides a safer flag that checks if your local view of the remote (`origin/feature/export-csv`) matches the actual remote before overwriting it. What flag is that?

---

### Hint 3: Exact Solution
From inside your `repo/` directory:

1. Confirm you are on `feature/export-csv`:
   ```bash
   git branch --show-current
   ```

2. Try a normal push to see the rejection:
   ```bash
   git push
   ```

3. Push using the lease safety check:
   ```bash
   git push --force-with-lease origin feature/export-csv
   ```
   *(Or simply `git push --force-with-lease` since tracking is already configured).*

4. Verify your mission:
   ```bash
   play check
   ```
