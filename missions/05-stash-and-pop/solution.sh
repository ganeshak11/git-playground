# shellcheck shell=bash
# Solution for Mission 5: Stash and Pop
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Stash in-progress changes, including untracked files (-u)
git stash -u -m "WIP coupon feature"

# 2. Switch to main
git switch main

# 3. Apply the hotfix in shop.py
cat << 'EOF' > shop.py
# Online Shop System

TAX_RATE = 0.05

def calculate_total(subtotal):
    return subtotal * (1 + TAX_RATE)
EOF

# 4. Commit the hotfix on main
git add shop.py
git commit -m "Fix sales tax rate to 5%"

# 5. Switch back to feature/discount
git switch feature/discount

# 6. Pop stashed changes back into the working directory
git stash pop
