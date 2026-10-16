# shellcheck shell=bash
# Mission 16 setup — creates a repository with 10 commits on main.
# The project has an automated test script (test.sh).
# At tag v1.0 (commit 1), test.sh passes.
# At commit 5 ("Refactor coupon discount rules"), a bug was introduced in cart.py
# that causes test.sh to fail from commit 5 onwards up to HEAD.
# The learner must use git bisect (manually or via git bisect run) to find the bad commit.

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # Commit 1: v1.0 base with passing tests
    cat << 'EOF' > .gitignore
__pycache__/
*.pyc
EOF

    cat << 'EOF' > README.md
# Shopping Cart Service
E-commerce shopping cart and coupon engine.
EOF

    cat << 'EOF' > cart.py
def calculate_discount(total, coupon):
    # SAVE10 gives 10% discount
    if coupon == "SAVE10":
        return total * 0.10
    return 0.0
EOF

    cat << 'EOF' > test.sh
#!/usr/bin/env bash
# Test discount calculation engine
# Returns 0 on success, 1 on failure
export PYTHONDONTWRITEBYTECODE=1
if command -v python3 >/dev/null 2>&1; then
    python3 -c "import cart; exit(0 if cart.calculate_discount(100, 'SAVE10') == 10 else 1)"
elif command -v python >/dev/null 2>&1; then
    python -c "import cart; exit(0 if cart.calculate_discount(100, 'SAVE10') == 10 else 1)"
else
    grep -q "return total \* 0.10" cart.py
fi
EOF
    chmod +x test.sh

    commit_as "LeadDev" "lead@example.com" "Initial cart and discount engine"
    git tag v1.0
    play_store "good_commit_hash" "$(git rev-parse HEAD)"

    # Commit 2
    cat << 'EOF' > customer.py
def get_customer(user_id):
    return {"id": user_id, "tier": "gold"}
EOF
    commit_as "Alice" "alice@example.com" "Add customer profile support"

    # Commit 3
    cat << 'EOF' > logger.py
def log_event(event):
    print(f"EVENT: {event}")
EOF
    commit_as "Bob" "bob@example.com" "Add order logging utility"

    # Commit 4
    cat << 'EOF' > currency.py
def format_usd(amount):
    return f"${amount:.2f}"
EOF
    commit_as "Charlie" "charlie@example.com" "Add currency formatting helper"

    # Commit 5: THE BUG (Breaks calculate_discount logic)
    cat << 'EOF' > cart.py
def calculate_discount(total, coupon):
    # REFACTORED: changed discount calculation
    # BUG: multiplied by 0.01 instead of 0.10!
    if coupon == "SAVE10":
        return total * 0.01
    return 0.0
EOF
    commit_as "DevOps" "devops@example.com" "Refactor coupon discount rules"
    play_store "culprit_hash" "$(git rev-parse HEAD)"

    # Commit 6
    cat << 'EOF' > summary.py
def generate_summary(items):
    return f"Total items: {len(items)}"
EOF
    commit_as "Alice" "alice@example.com" "Add order summary generator"

    # Commit 7
    cat << 'EOF' > tax.py
def calculate_tax(subtotal, rate=0.08):
    return subtotal * rate
EOF
    commit_as "Bob" "bob@example.com" "Add tax calculation utility"

    # Commit 8
    cat << 'EOF' > receipt.py
def print_receipt(order_id):
    return f"Receipt #{order_id}"
EOF
    commit_as "Charlie" "charlie@example.com" "Add order receipt printer"

    # Commit 9
    cat << 'EOF' > cache.py
def get_cached(key):
    return None
EOF
    commit_as "Alice" "alice@example.com" "Add cache layer for frequent queries"

    # Commit 10
    cat << 'EOF' >> README.md

## Running Tests
Run `./test.sh` to verify business logic.
EOF
    commit_as "LeadDev" "lead@example.com" "Update README test documentation"
)

say "Repository ready at repo/ on branch 'main'."
say "Tests passed at tag 'v1.0', but running './test.sh' at HEAD fails!"
say "Use 'git bisect' to find the exact commit that introduced the bug."
say "Write the culprit commit hash to 'culprit.txt' and reset bisect!"
