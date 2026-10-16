## Hint 1

Before switching to `main`, you must clear your working directory without losing your work.
Run `git stash -u` to save both your modified files and newly created untracked files (like `discount_notes.txt`).

After stashing, your working directory will be clean, allowing you to freely switch branches:

    git switch main

## Hint 2

Here is the general sequence of actions:

1. Stash your changes with untracked files: `git stash -u`
2. Switch to `main`: `git switch main`
3. Edit `shop.py` to change `TAX_RATE = 0.08` to `TAX_RATE = 0.05`
4. Stage and commit: `git add shop.py` then `git commit -m "Fix sales tax rate to 5%"`
5. Switch back to your branch: `git switch feature/discount`
6. Restore your work: `git stash pop`

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Stash in-progress work (including untracked files)
git stash -u -m "WIP coupon code"

# 2. Switch to main
git switch main

# 3. Apply the hotfix in shop.py
cat << 'EOF' > shop.py
# Online Shop System

TAX_RATE = 0.05

def calculate_total(subtotal):
    return subtotal * (1 + TAX_RATE)
EOF

# 4. Stage and commit the hotfix on main
git add shop.py
git commit -m "Fix sales tax rate to 5%"

# 5. Switch back to feature branch
git switch feature/discount

# 6. Pop your changes back out
git stash pop
```
