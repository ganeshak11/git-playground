# Core Git Concepts

Git feels confusing when you picture it as "folders moving through the cloud."
It becomes crystal clear when you understand the four mental models below.

---

## 1. A Remote Is Just a Folder

Everyone talks about "pushing to remote" like it's an abstract cloud service.
It's not.

- A git remote is **just another git repository at a path or URL**.
- It can live on GitHub, on a server across the globe, or in another folder on your own hard drive (`/path/to/repo.git`).
- A "bare" repository is simply a repository without a working directory — it only contains the `.git` database. That is all GitHub is hosting for you!

When you run `git push origin main`, git connects to that folder (or server), checks which commits they have, and transfers the missing commit objects and updates their ref pointer.

---

## 2. A Branch Is Just a 41-Byte Text File

A branch is **not** a copy of your files. It is **not** a folder.

A branch is a tiny pointer:
- Open your terminal and run `cat .git/refs/heads/main`.
- You will see exactly 40 hexadecimal characters (the commit SHA-1/SHA-256) followed by a newline.
- Creating a branch (`git branch feature`) doesn't duplicate any files; it writes 41 bytes to disk.
- Making a commit advances that 41-byte pointer to the new commit hash.

---

## 3. HEAD Is Just "Where Am I Right Now?"

`HEAD` is a reference file at `.git/HEAD`.

- Normally, `HEAD` points to a branch:
  `ref: refs/heads/main`
  This means: "I am on the `main` branch. When I make a commit, advance `main`."

- In a **detached HEAD** state, `HEAD` points directly to a commit hash instead of a branch:
  `d108de1234567890abcdef...`
  This means: "I am looking directly at this commit. If I commit now, no branch will track it!"

---

## 4. The Reflog Is Your Safety Net

Git almost **never** deletes commits immediately.

Even if you run `git reset --hard` or delete a branch with `git branch -D`, the commits are still stored in Git's object database for weeks before garbage collection cleans them up.

The **reflog** (`git reflog`) is an audit log of everywhere `HEAD` has moved.
If you ever think you lost work:
1. Run `git reflog`.
2. Find the commit hash from right before the mistake.
3. Run `git checkout <hash>` or `git branch rescue-branch <hash>`.
4. Your commits are back!
