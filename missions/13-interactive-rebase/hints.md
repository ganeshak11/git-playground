# Mission 13 Hints: Interactive Rebase (Squash and Drop)

### Hint 1: What is Interactive Rebase?
Interactive rebase (`git rebase -i <base>`) gives you a scriptable todo list of commits that you can reorder, edit, combine, or discard before sharing your branch with others.

When Git opens your text editor with the list of commits, each line begins with a command word (default is `pick`).
- To combine a commit into the one above it: change `pick` to `squash` (or `s`).
- To completely delete a commit from history: change `pick` to `drop` (or `d`), or delete that line entirely.

---

### Hint 2: Preparing the Todo List
From inside `repo/`:
1. Start interactive rebase targeting the `main` branch:
   ```bash
   git rebase -i main
   ```
2. In the editor that pops up, you will see 4 commits in chronological order (oldest at the top):
   - Commit 1: `Add user profile model` (keep as `pick`)
   - Commit 2: `Add avatar upload feature` (keep as `pick`)
   - Commit 3: `Fix typo in avatar upload` (change `pick` to `squash` so it merges into Commit 2)
   - Commit 4: `Add temporary debug print` (change `pick` to `drop` so it is erased)
3. Save the file and close your editor.
4. Git will apply the changes and may open another editor window asking for the combined commit message for the squashed commit. Save and close that editor as well.

---

### Hint 3: Full Step-by-Step Walkthrough
From inside your `repo/` directory:

1. Run:
   ```bash
   git rebase -i main
   ```

2. Your editor will show:
   ```text
   pick 1111111 Add user profile model
   pick 2222222 Add avatar upload feature
   pick 3333333 Fix typo in avatar upload
   pick 4444444 Add temporary debug print
   ```

3. Change it to:
   ```text
   pick 1111111 Add user profile model
   pick 2222222 Add avatar upload feature
   squash 3333333 Fix typo in avatar upload
   drop 4444444 Add temporary debug print
   ```

4. Save and close your editor:
   - **VS Code**: `Ctrl+S`, then `Ctrl+W`
   - **Nano**: `Ctrl+O`, `Enter`, then `Ctrl+X`
   - **Notepad**: `Ctrl+S`, then close the window
   - **Vim**: Press `Esc`, then type `:wq` and press `Enter`

5. When the message editor pops up for the combined avatar commit, save and close it.

6. Check your branch with:
   ```bash
   git log --oneline
   play check
   ```
