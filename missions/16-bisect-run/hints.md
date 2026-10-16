# Mission 16 Hints: Git Bisect (Find the Buggy Commit)

### Hint 1: What is Git Bisect?
When a regression appears in your codebase and there are many commits between the last known working release and the current broken state, testing every commit one by one is slow and tedious.

`git bisect` uses a **binary search** algorithm to cut the search space in half at each step. In just 3 or 4 checks, it can pinpoint the exact commit that broke the code out of dozens or hundreds of commits.

---

### Hint 2: Starting the Bisect
From inside `repo/`:
1. Start bisect by declaring the current broken state (`HEAD`) as bad and tag `v1.0` as good:
   ```bash
   git bisect start HEAD v1.0
   ```
2. Git checks out a midpoint commit.
3. You can run `./test.sh` to check if that midpoint is good or bad:
   - If it passes (exit 0): `git bisect good`
   - If it fails (exit 1): `git bisect bad`
4. Repeat until Git announces: `<hash> is the first bad commit`.
5. Write that hash to `culprit.txt`:
   ```bash
   echo "<hash>" > culprit.txt
   ```
6. Return to your branch:
   ```bash
   git bisect reset
   ```

---

### Hint 3: The Superpower (`git bisect run`)
You don't even have to test each commit manually! If you have a test script like `./test.sh` that exits with code 0 on success and non-zero on failure, Git can automate the entire search:

1. Inside `repo/`:
   ```bash
   git bisect start HEAD v1.0
   git bisect run ./test.sh
   ```
2. Git runs through all midpoint checks automatically in less than 2 seconds and prints:
   ```text
   <hash> is the first bad commit
   ```
3. Copy that hash and save it to `culprit.txt`:
   ```bash
   echo "<hash>" > culprit.txt
   ```
4. Reset bisect to return to `main`:
   ```bash
   git bisect reset
   ```
5. Check your solution:
   ```bash
   play check
   ```
