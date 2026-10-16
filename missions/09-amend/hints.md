## Hint 1

To fix the commit without creating a second "oops" commit, you need to:
1. Put `test_auth.py` into your Staging Area using `git add`.
2. Amend the previous commit using `git commit --amend`.

## Hint 2

Run `git add test_auth.py` first.
Then pass `-m` to `git commit --amend` with the properly spelled message:

    git commit --amend -m "Add biometric auth support and unit tests"

This folds `test_auth.py` into the commit and replaces the typo in the message.

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Stage the forgotten test file
git add test_auth.py

# 2. Amend the commit with the corrected message and file
git commit --amend -m "Add biometric auth support and unit tests"
```
