# Mission 0: Remote Is Just a Folder

---

## 1. The Mental Model: What Is a Remote?

Everyone talks about "pushing to a remote" or "uploading to GitHub" like it's a mysterious internet cloud service.

### The Reality Under the Hood
In Git:
- **A remote is just another Git repository at a path or URL.**
- It can live on GitHub, on an internal company server, or right here in a folder on your own hard drive (e.g. `../team-remote.git`).
- When you "push", Git doesn't run some proprietary cloud sync protocol. It simply copies commit objects from your local `.git` folder to the target repo's `.git` folder and updates its ref pointer!

---

## 2. Working Repositories vs. Bare Repositories

To understand remotes and servers like GitHub, you need to understand the difference between two types of Git repositories:

### A Working Repository (`git init`)
When you run `git init my-project`:
- Git creates a working tree: a folder where you can view, edit, and create your project files.
- It puts Git's internal database in a hidden `.git` subdirectory.

```
my-project/
├── .git/            <-- Git database (history, commits, refs)
├── README.md        <-- Working tree (your actual files)
└── index.js         <-- Working tree
```

### A Bare Repository (`git init --bare`)
When you run `git init --bare team-remote.git`:
- **There are no working tree files.** You cannot edit files directly inside it.
- The folder itself *is* the Git database. You will see `HEAD`, `config`, `objects/`, and `refs/` directly at the root.
- **Why?** Servers (like GitHub, GitLab, or team file shares) store code as bare repositories so that multiple developers can push to them without colliding with someone else's uncommitted working files.

GitHub is essentially a cluster of Linux servers hosting bare Git repositories with a nice web interface on top!

```
team-remote.git/     <-- A bare repo (Notice: no source code files, only git internals!)
├── HEAD
├── config
├── objects/
└── refs/
```

---

## 3. How Repositories Communicate

In this mission, you are going to simulate a full team workflow right on your computer:

```
                      +-------------------+
                      |  team-remote.git  |
                      |   (bare repo)     |
                      +-------------------+
                        ^               |
     1. Push commit     |               | 2. Clone / pull
                        |               v
              +------------+         +----------------+
              | my-project |         | teammate-clone |
              |  (Clone 1) |         |   (Clone 2)    |
              +------------+         +----------------+
```

1. You create a bare repository (`team-remote.git`) to act as the shared team central repo.
2. You clone from `team-remote.git` into `my-project`.
3. In `my-project`, you create a file, commit it, and push it to `team-remote.git`.
4. You clone `team-remote.git` into `teammate-clone`, simulating a coworker downloading your work.
5. Both clones now share the exact same commit history!

---

## 4. Useful Commands for This Mission

- `git init --bare --initial-branch=main <folder-name>`
  Creates a bare Git repository with `main` as the default branch. The `.git` naming convention (e.g. `team-remote.git`) is standard for bare repositories.

- `git clone <path-or-url> <folder-name>`
  Clones a repository into a new folder. Git automatically sets up a remote called `origin` pointing back to `<path-or-url>`.

- `git remote -v`
  Lists the URLs/paths of all configured remotes for the current repository.

- `git push origin main`
  Sends commits from your local `main` branch to the remote named `origin`.

---

## 5. Your Mission Tasks

You are standing in an empty sandbox workspace. Complete the following steps:

### Step 1: Create the bare remote repository
```bash
git init --bare --initial-branch=main team-remote.git
```
Peek inside `team-remote.git/`:
```bash
ls team-remote.git
```
Notice: `HEAD`, `config`, `objects`, `refs`. No source files!

### Step 2: Clone from it into a working project
```bash
git clone team-remote.git my-project
```
*(Git may show a warning: `You appear to have cloned an empty repository.` This is completely normal because no commits have been pushed yet).*

### Step 3: Enter `my-project` and set local identity
```bash
cd my-project
git config user.name "You"
git config user.email "you@example.com"
```
Check that Git configured `origin` for you:
```bash
git remote -v
```

### Step 4: Create a file, commit, and push
```bash
echo "# Task Tracker" > README.md
echo "A simple task tracking app." >> README.md
git add README.md
git commit -m "Initial commit: add README"
git push origin main
```

### Step 5: Simulate a coworker cloning the project
Go back up to the sandbox root, and clone the remote a second time into a different directory:
```bash
cd ..
git clone team-remote.git teammate-clone
```

### Step 6: Verify both clones agree
Check the latest commit hash in both clones:
```bash
git -C my-project rev-parse HEAD
git -C teammate-clone rev-parse HEAD
```
Both hashes match! Both clones are in sync through your local folder remote.

### Step 7: Verify your mission
Run:
```bash
play check
```

---

## 6. Check Your Understanding

Before moving to the next mission, you should be able to explain:
- [ ] What is the difference between `git init` and `git init --bare`?
- [ ] Why do servers like GitHub use bare repositories instead of regular repositories?
- [ ] Does a Git remote have to be on the internet?
- [ ] What does `origin` mean in Git? *(It is simply the default name given to the remote you cloned from).*
