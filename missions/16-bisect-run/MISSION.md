# Mission 16: Bisect: Find the Bug with Binary Search

## The Situation
You arrive at work on Monday and the continuous integration test suite is red! The test script `./test.sh` is failing with a coupon discount calculation mismatch.

The last known working release was tagged **`v1.0`**. Since that tag, the team merged 9 different commits covering logging, tax, customer accounts, and caching.

One of those commits broke the discount logic, but nobody knows which one. Manually checking out every commit to run tests is slow. You need to identify the exact regression commit quickly using Git's binary search engine: **`git bisect`**.

---

## 1. The Mental Model & Under-the-Hood Mechanics

### Why Binary Search Matters
If there are 1,000 commits between a working release and a broken build, checking every commit sequentially ($O(N)$) requires 1,000 test runs.

`git bisect` uses **binary search** ($O(\log_2 N)$):
- Cut the range in half -> test midpoint.
- If midpoint is bad, the bug was introduced in the older half.
- If midpoint is good, the bug was introduced in the newer half.
- Cut in half again, and repeat.

For 1,000 commits, Git finds the exact culprit in **at most 10 tests** ($2^{10} = 1024$). For our 10 commits, it takes just **3 to 4 steps**!

```
HOW GIT BISECT NARROW DOWN COMMITS:

v1.0 (GOOD) ───> C2 ───> C3 ───> C4 ───> C5 [BUG] ───> C6 ───> C7 ───> C8 ───> C9 ───> HEAD (BAD)

Step 1: Git checks out C5 (midpoint).
        Run test -> FAILS! C5 is BAD.
        The bug is between v1.0 and C5.

Step 2: Git checks out C3.
        Run test -> PASSES! C3 is GOOD.
        The bug is between C3 and C5.

Step 3: Git checks out C4.
        Run test -> PASSES! C4 is GOOD.
        C4 is good, C5 is bad!
        ==> Result: C5 is the first bad commit!
```

---

### Manual Bisect vs. Automated `git bisect run`

You can perform bisect manually:
1. `git bisect start HEAD v1.0`
2. Run your test manually.
3. Type `git bisect good` or `git bisect bad`.
4. Repeat until done.

**Or you can use Git's automated superpower:**
```bash
git bisect run <script>
```
Git will autonomously checkout midpoints, run `<script>`, inspect the exit code, mark the commit good/bad, and pinpoint the culprit in seconds!

#### The Unix Exit Code Contract for `git bisect run`:
- Exit Code **`0`**: The test passed (**GOOD**).
- Exit Code **`1` to `127`** (except 125): The test failed (**BAD**).
- Exit Code **`125`**: The commit cannot be tested (skip this commit).

---

### The Cleanup: `git bisect reset`
During a bisect session, Git puts your repository in a **detached HEAD** state as it jumps between commits. When bisect is finished, you must run:
```bash
git bisect reset
```
This ends the bisect session and returns `HEAD` back to your original branch (`main`).

---

## 2. Command Reference

| Command | What it does |
|---|---|
| `git bisect start <bad> <good>` | Initiates a bisect session between known bad and good commits |
| `git bisect bad` | Marks the currently checked-out commit as BAD |
| `git bisect good` | Marks the currently checked-out commit as GOOD |
| `git bisect run <script>` | Automates the entire bisect process using a test script |
| `git bisect log` | Shows the history of tested commits during the session |
| `git bisect reset` | Cleans up and returns to the branch you were on before bisecting |

---

## 3. Step-by-Step Hands-On Tasks

### Step 1: Navigate to the repository
```bash
cd repo
```

### Step 2: Observe the failure at HEAD
Run the project test script:
```bash
./test.sh
```
Notice that it exits with failure!

### Step 3: Start the bisect session
Declare that `HEAD` is broken and `v1.0` was working:
```bash
git bisect start HEAD v1.0
```
Git will output the number of revisions left to test (roughly 3 steps).

### Step 4: Let Git find the bug automatically!
Run:
```bash
git bisect run ./test.sh
```
*(If running on Windows Git Bash, you can also run `git bisect run bash ./test.sh`)*.

Watch Git checkout commits, execute `./test.sh` on each, and announce:
```text
<commit-hash> is the first bad commit
commit <commit-hash>
Author: ...
    Refactor coupon discount rules
```

### Step 5: Inspect the culprit commit
See exactly what broke the code:
```bash
git show <commit-hash>
```
Notice the typo: `return total * 0.01` instead of `return total * 0.10`!

### Step 6: Record the culprit hash
Write the bad commit hash (short or full) into `culprit.txt`:
```bash
echo "<commit-hash>" > culprit.txt
```

### Step 7: Clean up and reset bisect
Return to your `main` branch:
```bash
git bisect reset
```

### Step 8: Verify your mission
Run:
```bash
play check
```

---

## 4. Check Your Understanding
Before moving to the next mission, verify you can answer these questions:
- [ ] What is the time complexity of `git bisect` compared to testing commits linearly?
- [ ] What exit code must a test script return for `git bisect run` to consider a commit "good"?
- [ ] What state does Git place your repository in during a bisect session?
- [ ] Why must you always run `git bisect reset` when you are done?
