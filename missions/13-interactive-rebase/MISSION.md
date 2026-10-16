# Mission 13: Interactive Rebase: Squash and Drop

## The Situation
You have been building a new user profile feature on branch `feature/profile-system`. Like most developers in the flow of coding, you made incremental commits as you went:
1. You created the initial user profile model.
2. You added avatar uploading.
3. You immediately noticed a typo in the avatar uploader and committed a quick fix: `"Fix typo in avatar upload"`.
4. You added a quick `print` debug statement that logs sensitive auth tokens to the console to debug a local issue: `"Add temporary debug print"`.

Now your feature is ready for code review! But before opening a Pull Request (PR) for your teammates, team policy requires you to clean up your branch:
- **Squash** the tiny typo fix into the avatar upload commit so it forms one logical, polished unit of work.
- **Drop** the temporary debug statement completely so sensitive debugging code never touches production.

---

## 1. The Mental Model & Under-the-Hood Mechanics

### What is Interactive Rebase?
`git rebase -i` (short for `--interactive`) is Git's Swiss Army knife for curating branch history. It opens a text editor with a **todo list** of commits, allowing you to script exactly what Git should do to each commit: reorder them, combine them, edit messages, or delete them.

> **Crucial Detail:** Unlike `git log` (which lists the newest commit at the top), the interactive rebase todo list is written in **chronological order** (oldest commit at the top, newest at the bottom).

```
BEFORE REBASE:
main ───> C1 [Profile Model] ───> C2 [Avatar Upload] ───> C3 [Typo fix] ───> C4 [Debug log] (HEAD)

TODO LIST ACTIONS:
  pick   C1 Add user profile model
  pick   C2 Add avatar upload feature
  squash C3 Fix typo in avatar upload      <-- combined into C2
  drop   C4 Add temporary debug print       <-- erased completely

AFTER REBASE:
main ───> C1' [Profile Model] ───> C2' [Avatar Upload + Typo Fix] (HEAD)
```

---

### The Action Words in the Todo List

When the todo list opens in your editor, each line starts with a command word:

| Command | Short | What Git does |
|---|---|---|
| `pick` | `p` | Keep this commit exactly as it is. |
| `reword` | `r` | Keep the commit's code changes, but stop to let you edit the commit message. |
| `edit` | `e` | Pause the rebase here so you can add/remove files or amend the commit. |
| `squash` | `s` | **Meld this commit into the commit immediately above it.** Combines both commit messages into one. |
| `fixup` | `f` | Like `squash`, but automatically discards this commit's message (keeps only the previous commit's message). |
| `drop` | `d` | **Delete this commit entirely.** (You can also simply delete the line from the file). |

### What Happens During `squash`?
When you mark `C3` with `squash`, Git applies `C2`, then applies `C3` on top of it, stages the combined changes, and opens a secondary editor window displaying both commit messages. You can edit the text to summarize both changes cleanly, or leave it as-is.

### The Panic Button: `git rebase --abort`
If you ever get confused, make an editing mistake, or feel lost during an interactive rebase:
```bash
git rebase --abort
```
This instantly rolls back the entire operation and returns your branch to the exact state it was in before you ran `git rebase -i`.

---

## 2. Editor Survival Guide
Git opens your configured text editor (VS Code, Nano, Notepad, or Vim) to edit the todo list:

- **VS Code:** Make your changes, save (`Ctrl+S` / `Cmd+S`), and close the tab (`Ctrl+W` / `Cmd+W`).
- **Nano:** Make your changes, save with `Ctrl+O` followed by `Enter`, then exit with `Ctrl+X`.
- **Notepad:** Make your changes, save (`Ctrl+S`), then close the window.
- **Vim:** Press `i` to enter edit mode, make your edits, press `Esc`, then type `:wq` and press `Enter`.

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Inspect your branch commits
View the 4 commits on your feature branch relative to `main`:
```bash
git log --oneline main..HEAD
```

### Step 3: Start interactive rebase against `main`
```bash
git rebase -i main
```

### Step 4: Edit the todo list
Your editor will open showing 4 lines:
```text
pick <hash1> Add user profile model
pick <hash2> Add avatar upload feature
pick <hash3> Fix typo in avatar upload
pick <hash4> Add temporary debug print
```

Modify the commands:
1. Leave `<hash1>` as `pick`.
2. Leave `<hash2>` as `pick`.
3. Change `<hash3>` from `pick` to `squash` (or `s`).
4. Change `<hash4>` from `pick` to `drop` (or `d`).

Save and close the file.

### Step 5: Save the combined commit message
Git will apply the rebase and open another editor displaying the combined commit message for the squashed avatar commits. Save and close this editor.

### Step 6: Verify the cleaned-up branch
1. Check your commit log:
   ```bash
   git log --oneline main..HEAD
   ```
   You should see exactly **2 clean commits**. The typo fix is combined with the avatar feature, and the debug commit is gone!
2. Verify `profile.py` no longer contains the debug statement:
   ```bash
   cat profile.py
   ```
3. Verify `avatar.py` has the clean code:
   ```bash
   cat avatar.py
   ```

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] In what order does `git rebase -i` list commits (chronological vs reverse-chronological)?
- [ ] What is the difference between `squash` and `fixup`?
- [ ] What does `drop` do to a commit and its changes?
- [ ] How do you abort a rebase if you make an error?
- [ ] Why is it good practice to squash and drop commits locally before opening a Pull Request?
