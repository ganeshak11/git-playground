# Git Playground

Learn git by fixing broken repos, not by reading docs.

## What is this?

A set of hands-on missions that teach git through practice. Each mission gives
you a broken or incomplete git scenario and asks you to fix it. No multiple
choice, no videos — just you and git.

## Prerequisites

- **Git 2.28 or later** — [download here](https://git-scm.com)
- That's it. No Python, no Node, no Docker.

## Quick Start

### Linux / macOS

```bash
git clone https://github.com/YOUR-USERNAME/git-playground.git
cd git-playground
chmod +x play
./play doctor
./play start 0
```

### Windows (Git Bash — recommended)

```bash
git clone https://github.com/YOUR-USERNAME/git-playground.git
cd git-playground
./play doctor
./play start 0
```

### Windows (cmd or PowerShell)

```cmd
git clone https://github.com/YOUR-USERNAME/git-playground.git
cd git-playground
play.cmd doctor
play.cmd start 0
```

### WSL

Follow the Linux instructions.

## Commands

| Command | What it does |
|---|---|
| `play doctor` | Check your setup (git version, identity, sandbox path) |
| `play list` | Show all missions with completion status |
| `play start N` | Set up mission N and print the goal |
| `play check` | Verify your solution for the current mission |
| `play hint` | Get the next hint (they escalate from vague to specific) |
| `play reset` | Wipe the current mission's sandbox and restart |
| `play solution N` | Show the reference solution (after confirmation) |

## How It Works

Each mission creates a **sandbox** outside this repo
(at `~/git-playground-sandbox/`) so your git commands never accidentally
hit the course repo's files.

The sandbox contains real git repos — there's no simulation layer. When a
mission says "your remote is ahead," there's an actual bare repository
with real commits pushed by a simulated teammate.

## Missions

**Tier 0: What's actually happening**
- 00 — Remote Is Just a Folder
- 01 — A Branch Is Just a Pointer
- 02 — Look Before You Commit

**Tier 1: Basics**
- 03 — Push Rejected
- 04 — Merge Conflict
- 05 — Stash and Pop
- 06 — Undo the Last Commit

**Tier 2: Everyday Fixes**
- 07 — Cherry-Pick
- 08 — Detached HEAD
- 09 — Amend a Commit

**Tier 3: Recovery**
- 10 — Rescuing a Deleted Branch
- 11 — Undoing an Accidental reset --hard
- 12 — Revert a Pushed Bad Commit
- 13 — Interactive Rebase: Squash and Drop

**Tier 4: Real Job**
- 14 — Rebase Onto Moved Main
- 15 — Force-Push After Rebase (--force-with-lease)
- 16 — Bisect (Find the Bug with Binary Search)
- 17 — Accidental Push to Main & Incident Response
- 18 — Capstone Sprint: Full Team Collaboration

*Complete course: 19 interactive hands-on missions (00 through 18).*

## Documentation & Guides

- [Core Concepts](docs/CONCEPTS.md) — The 4 mental models that demystify Git
- [Git Cheatsheet](docs/CHEATSHEET.md) — The 20 commands you actually need, one line each
- [Panic Manual](docs/RESET.md) — What to do when you broke something

## I Broke Something

Run `play reset` to wipe the current mission's sandbox and start fresh.
Your progress on other missions is not affected. See [docs/RESET.md](docs/RESET.md) for more help.

## Troubleshooting

**`$'\r': command not found`**
Line ending issue. The `.gitattributes` file should prevent this.
If it happens: `git config --global core.autocrlf false`, delete the repo,
and clone again.

**`play: Permission denied`**
Run `chmod +x play` (Linux/macOS only; not needed in Git Bash).

**Unicode symbols garbled (✓ ▸ ─)**
Set `export PLAY_ASCII=1` before running play, or add it to your shell profile.
This auto-enables on Windows outside of Git Bash's mintty terminal.

**`git log` opens a pager and you're stuck**
Press `q` to exit.

## Environment Variables

| Variable | Default | Purpose |
|---|---|---|
| `GIT_PLAYGROUND_SANDBOX` | `~/git-playground-sandbox` | Where mission sandboxes are created |
| `PLAY_ASCII` | auto | Set to `1` for ASCII-only output |
