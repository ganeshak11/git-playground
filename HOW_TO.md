# How to Play: The Complete User Manual

Welcome to **Git Playground**! This guide walks you through the exact setup, terminal commands, directory navigation, and workflows you need to master Git through hands-on repair missions.

---

## 1. The Core Mental Model: Two Folders

When using Git Playground, you navigate between **two separate folders** on your system:

```
+-----------------------------------------------------------------------------------------+
| FOLDER 1: Course Control Center                                                         |
| Path:  /home/ganeshak11/dev/Learning/git-playground                                     |
| What:  Where the course lives. You run `play` commands here to start, check, or reset.  |
+-----------------------------------------------------------------------------------------+
                                           │
                            play start 0   │ creates your workspace
                                           ▼
+-----------------------------------------------------------------------------------------+
| FOLDER 2: Your Mission Sandbox                                                          |
| Path:  ~/git-playground-sandbox/00/repo/                                                |
| What:  A real, broken Git repo generated for you. You run actual `git` commands here.   |
+-----------------------------------------------------------------------------------------+
```

> [!IMPORTANT]
> **Safety Guarantee:** Your work happens strictly inside `~/git-playground-sandbox/`. You can experiment fearlessly with destructive commands (`git reset --hard`, `git push --force`, deleting branches) without any risk of damaging the course repository or your own projects.

---

## 2. Recommended Terminal Setups

### Option A: The Two-Terminal Split (Recommended)
Open two terminal windows (or split your terminal into two panes):

* **Left Terminal (Controller):** Stay in `/home/ganeshak11/dev/Learning/git-playground`
  * Runs: `play start 0`, `play check`, `play hint`, `play reset`
* **Right Terminal (Workspace):** Stay in `~/git-playground-sandbox/00/repo`
  * Runs: `git status`, `git log`, `git commit`, `git switch`, etc.

### Option B: Single Terminal with Alias
If you prefer using a single terminal window, set up an alias so `play` works from inside any sandbox directory:

```bash
# Add to ~/.bashrc or ~/.bash_aliases:
alias play='/home/ganeshak11/dev/Learning/git-playground/play'

# Reload your shell:
source ~/.bashrc  # (or source ~/.bash_aliases)
```

Now you can `cd` into your sandbox and run `play check` directly without returning to the course folder!

---

## 3. Step-by-Step Mission Lifecycle

Here is the exact cycle you repeat for every mission from 00 to 18:

```
                  ┌──────────────────────────────────────────┐
                  │ 1. play start N                          │
                  │    (spins up sandbox & prints guide)     │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 2. cd ~/git-playground-sandbox/NN/repo   │
                  │    (enter the broken workspace)          │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 3. Run git commands                      │
                  │    (inspect, fix, commit, revert, etc.)  │
                  └────────────────────┬─────────────────────┘
                                       │
                                       ▼
                  ┌──────────────────────────────────────────┐
                  │ 4. play check                            │
                  │    (verifies resulting Git state)        │
                  └─────────┬──────────────────────┬─────────┘
                            │                      │
                     Passed │                      │ Failed
                            ▼                      ▼
           ┌────────────────────────┐   ┌───────────────────────────┐
           │ 5. Move to Mission N+1 │   │ • play hint (get a nudge) │
           │    play start N+1      │   │ • play reset (start over) │
           └────────────────────────┘   └───────────────────────────┘
```

---

## 4. Concrete Walkthrough Example: Mission 00

Let's walk through an entire mission from start to finish.

### Step 1: Health Check
Verify your environment (run inside course repo or using your alias):
```bash
play doctor
```
Output:
```text
✓ git found: git version 2.53.0
✓ git version 2.53 (>= 2.28)
✓ user.name: your-name
✓ user.email: your-email@example.com
✓ Sandbox location: /home/ganeshak11/git-playground-sandbox
✓ Sandbox is not inside another git repo

✓ Everything looks good. Run 'play start 0' to begin!
```

---

### Step 2: View Curriculum Progress
```bash
play list
```
Displays all 19 missions (00 through 18) with completion markers `[✓]`.

---

### Step 3: Start Mission 00
```bash
play start 0
```
This builds the sandbox at `~/git-playground-sandbox/00/` and displays the mission tutorial (`MISSION.md`).
The final line tells you where to work:
```text
▸ Your workspace is: /home/ganeshak11/git-playground-sandbox/00
▸ cd there and start working. Run 'play check' when you're done.
```

---

### Step 4: Enter the Workspace
```bash
cd ~/git-playground-sandbox/00
ls -la
```
You will see:
* `remote.git/` — A real bare repository simulating GitHub.
* `my-project/` — Your working repository.

Enter your working repository:
```bash
cd my-project
```

---

### Step 5: Solve the Mission
Follow the instructions provided in Mission 00:
```bash
# 1. Connect your repo to the bare remote
git remote add origin ../remote.git

# 2. Push main and set up tracking
git push -u origin main

# 3. Simulate a teammate cloning from the remote
cd ..
git clone remote.git teammate-clone
```

---

### Step 6: Verify Your Solution
From the course repo (or anywhere if you set up the alias):
```bash
play check
```
Output:
```text
✓ Remote successfully configured, branch pushed, and tracking verified!

▸ Next up: play start 1
```

---

## 5. What to Do If You Get Stuck

### 1. Request an Escalating Hint
```bash
play hint
```
Hints escalate across 3 levels:
* **Hint 1 (Conceptual):** Explains the mental model behind the problem.
* **Hint 2 (Tactical):** Identifies the exact files or inspection tools to examine.
* **Hint 3 (Exact Commands):** Gives you the exact commands to run.

### 2. Made a Mess? Reset the Mission
If your working tree gets tangled or you want a fresh start:
```bash
play reset
```
> [!NOTE]
> `play reset` deletes **only** the current mission's sandbox (`~/git-playground-sandbox/NN/`) and rebuilds it from scratch. None of your other completed missions are touched.

### 3. View the Reference Solution
If you are completely blocked and want to inspect the official solution:
```bash
play solution 0
```
*(Prompts for a `[y/N]` confirmation so you don't spoil it by accident, then prints the exact reference script).*

---

## 6. Playground Command Reference

| Command | Where to run it | What it does |
|---|---|---|
| `play doctor` | Anywhere | Checks Git version ($\ge 2.28$), user identity, and sandbox location |
| `play list` | Anywhere | Displays all 19 missions with completion checkmarks `[✓]` |
| `play start N` | Anywhere | Initializes sandbox for mission `N` and prints the mission guide |
| `play check` | Anywhere | Verifies your solution for the active mission |
| `play hint` | Anywhere | Shows the next escalating hint (Levels 1 $\to$ 3) |
| `play reset` | Anywhere | Wipes the active mission sandbox and starts it fresh |
| `play solution N` | Anywhere | Reveals the reference solution script after confirmation |
| `play help` | Anywhere | Shows the quick command-line reference |

---

## 7. Platform Specifics

### Linux / macOS
Run commands directly with `./play <command>` from the course repository, or create an alias in `~/.bashrc` / `~/.zshrc`:
```bash
alias play='/path/to/git-playground/play'
```

### Windows (Command Prompt / PowerShell)
Use the included Windows wrapper [`play.cmd`](file:///home/ganeshak11/dev/Learning/git-playground/play.cmd):
```cmd
play.cmd doctor
play.cmd start 0
play.cmd check
```
The wrapper automatically locates your Git Bash installation (`bash.exe`), escapes paths, and forwards all arguments.

### Windows (Git Bash)
You can run `./play` just like on Linux:
```bash
./play doctor
./play start 0
./play check
```

---

## 8. Troubleshooting FAQ

#### Q: Typing `play` runs an existing audio/media player or custom function!
A: Some systems have an audio binary or shell function named `play`.
1. Check what it is: `type play`
2. If it's a function, unset it for your session: `unset -f play`
3. Point `play` directly to Git Playground in your `~/.bash_aliases`:
   ```bash
   alias play='/home/ganeshak11/dev/Learning/git-playground/play'
   ```

#### Q: "Mission N already started. Reset and restart? [y/N]"
A: You previously started this mission. Press `y` to wipe and recreate the exercise from step 1, or `N` to keep your existing sandbox and continue where you left off.

#### Q: Git opened a pager (`less`) during `git log` and the terminal is stuck!
A: Press `q` to exit the pager and return to your prompt.

#### Q: Git opened Vim for a commit message and I can't exit!
A: Press `Esc`, type `:wq`, and press `Enter` to save and exit (or `:q!` to discard).
*(Git Playground sets `core.editor` locally to `nano`, `notepad`, or `code --wait` whenever available to prevent trapping you in Vim).*
