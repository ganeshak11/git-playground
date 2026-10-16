# Mission 18 Hints: The Capstone Sprint

### Hint 1: The Modern Team Sprint Workflow
Here is what you need to do to complete your sprint:
1. Update your local `main` branch so it includes teammate Alex's commits from `origin/main`.
2. Switch back to your `feature/notifications` branch and rebase onto `main`.
3. When Git pauses on the conflict in `config.json`, open the file and keep **both** features: `"audit_logging"` and `"notifications"`.
4. Stage the resolved file (`git add config.json`) and run `git rebase --continue`.
5. Update your remote feature branch using `git push --force-with-lease`.
6. Switch to `main`, merge your feature branch (`git merge feature/notifications`), and push `main` to `origin/main`!

---

### Hint 2: Resolving the Conflict in `config.json`
During `git rebase main`, Git will stop and warn that `config.json` has a conflict.
Open `config.json`. The conflicted `features` list should look like this:
```json
{
  "app_name": "Task Tracker",
  "version": "1.0",
  "features": [
    "task_management",
    "audit_logging",
    "notifications"
  ]
}
```
After editing `config.json`:
```bash
git add config.json
git rebase --continue
```

---

### Hint 3: Full Step-by-Step Walkthrough
From inside your `repo/` directory:

1. Update `main` from origin:
   ```bash
   git switch main
   git pull origin main
   ```

2. Rebase your feature branch onto the updated `main`:
   ```bash
   git switch feature/notifications
   git rebase main
   ```
   *(Git will notify you of a conflict in `config.json`)*.

3. Resolve the conflict by updating `config.json` to:
   ```json
   {
     "app_name": "Task Tracker",
     "version": "1.0",
     "features": [
       "task_management",
       "audit_logging",
       "notifications"
     ]
   }
   ```

4. Stage the resolved file and continue the rebase:
   ```bash
   git add config.json
   git rebase --continue
   ```

5. Push your rebased feature branch to origin with lease:
   ```bash
   git push --force-with-lease origin feature/notifications
   ```

6. Switch to `main`, fast-forward merge your feature, and push:
   ```bash
   git switch main
   git merge feature/notifications
   git push origin main
   ```

7. Celebrate and check your mission:
   ```bash
   play check
   ```
