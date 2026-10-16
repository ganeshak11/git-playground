# Mission 17 Hints: Incident Response (Accidental Push to Main)

### Hint 1: The Strategy
Before touching `main`, make sure you don't lose the experimental code you wrote!
1. Point a new branch (`feature/payment-gateway`) at your current commit so your code is safe.
2. Now that your code is safely preserved on the branch, fix `main`: use `git revert` to undo the broken commit on `main`, and push the revert to `origin/main`.
3. Create `INCIDENT.md` in the repo root documenting the cause, fix, and prevention.

---

### Hint 2: Step-by-Step Commands
1. Create the feature branch pointing at your current commit:
   ```bash
   git branch feature/payment-gateway
   ```
2. Make sure you are on `main`:
   ```bash
   git switch main
   ```
3. Revert the accidental commit on `main`:
   ```bash
   git revert --no-edit HEAD
   ```
4. Push the revert to the remote:
   ```bash
   git push origin main
   ```
5. Create `INCIDENT.md` and write a brief description covering:
   - What happened (direct push to main)
   - Remediation (reverting main and rescuing work to a branch)
   - Prevention (branch protection rules / requiring pull requests)

---

### Hint 3: Exact Walkthrough
From inside your `repo/` directory:

1. Preserve your experimental code on a new branch:
   ```bash
   git branch feature/payment-gateway
   ```

2. Revert the bad commit on `main`:
   ```bash
   git revert --no-edit HEAD
   ```

3. Push the fix to `origin/main`:
   ```bash
   git push origin main
   ```

4. Create `INCIDENT.md`:
   ```bash
   cat << 'EOF' > INCIDENT.md
   # Incident: Accidental Direct Push to Main
   
   - **What happened:** Accidental direct push to main without a branch.
   - **Remediation:** Used git revert on main and rescued code to feature/payment-gateway.
   - **Prevention:** Enable GitHub branch protection rules to require pull requests.
   EOF
   ```

5. Verify your mission:
   ```bash
   play check
   ```
