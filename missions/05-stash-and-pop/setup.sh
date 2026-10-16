# shellcheck shell=bash
# Mission 5 setup — sets up a repository on feature/discount with uncommitted
# in-progress work and an untracked notes file.

make_repo "repo"

(
    cd "${SANDBOX}/repo" || exit 1

    # 1. Base project on main
    cat << 'EOF' > shop.py
# Online Shop System

TAX_RATE = 0.08

def calculate_total(subtotal):
    return subtotal * (1 + TAX_RATE)
EOF

    commit_as "You" "you@example.com" "Initial release of shop system"

    # 2. Create and switch to feature branch
    git branch feature/discount
    git switch feature/discount >/dev/null 2>&1

    # 3. Create in-progress changes in shop.py
    cat << 'EOF' > shop.py
# Online Shop System

TAX_RATE = 0.08

def calculate_total(subtotal):
    return subtotal * (1 + TAX_RATE)

# Work-in-progress discount code:
def apply_coupon(subtotal, code):
    if code == "SAVE20":
        return subtotal * 0.8
    return subtotal
EOF

    # 4. Create untracked notes file
    cat << 'EOF' > discount_notes.txt
TODO: Test expired coupons and negative discounts.
EOF
)

say "Repository ready at repo/ on branch 'feature/discount'."
say "You have in-progress edits in shop.py and untracked discount_notes.txt."
say "A production hotfix is needed on 'main': change TAX_RATE to 0.05!"
