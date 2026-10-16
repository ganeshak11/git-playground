# Mission 14 Hints: Rebase Onto Moved Main

### Hint 1: Merge vs Rebase
When the branch you branched off (`main`) moves forward with new commits while you are working on your feature branch, you have two choices:
1. `git merge main`: Combines history by creating a new merge commit.
2. `git rebase main`: Unplugs your feature commits, fast-forwards your branch to the tip of `main`, and replays your commits one by one on top of `main`.

Rebase creates a beautiful, straight, linear history without cluttered merge commits.

---

### Hint 2: Inspecting the Graph
1. First, see the divergence visually:
   ```bash
   git log --graph --oneline --all
   ```
   You will see `main` has moved ahead on one branch of the fork, and `feature/search-filter` is on another.
2. Make sure you are on `feature/search-filter`:
   ```bash
   git branch --show-current
   ```
3. Rebase onto `main`:
   ```bash
   git rebase main
   ```

---

### Hint 3: Exact Solution
From inside your `repo/` directory:

1. Confirm you are on `feature/search-filter`:
   ```bash
   git switch feature/search-filter
   ```

2. Rebase onto the latest `main`:
   ```bash
   git rebase main
   ```

3. View the new linear history graph:
   ```bash
   git log --graph --oneline
   ```
   Notice how your two feature commits now sit directly on top of `main`!

4. Verify your mission:
   ```bash
   play check
   ```
