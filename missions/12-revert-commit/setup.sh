# shellcheck shell=bash
# Mission 12 setup — creates a bare remote and a clone where 4 commits have been pushed.
# A middle commit (Commit 2) introduced a buggy/illegal fee calculation in billing.py,
# followed by legitimate commits (receipt generator, README updates).
# The learner must revert the middle commit without losing subsequent work and push to remote.

# 1. Create bare remote
make_bare_remote "remote.git"

# 2. Clone into working repository
git clone "${SANDBOX}/remote.git" "${SANDBOX}/repo" >/dev/null 2>&1

(
    cd "${SANDBOX}/repo"
    git config user.name "You"
    git config user.email "you@example.com"
    git config core.autocrlf false

    # Commit 1: Initial billing foundation
    cat << 'EOF' > README.md
# Billing Service
Core payment and billing system.
EOF

    cat << 'EOF' > billing.py
def calculate_base_total(items):
    return sum(item["price"] for item in items)

def calculate_total(items):
    return calculate_base_total(items)
EOF

    commit_as "Teammate" "team@example.com" "Initial setup of billing service"
    git push -u origin main >/dev/null 2>&1

    # Commit 2: Buggy middle commit (illegal surcharge fee)
    cat << 'EOF' > billing.py
def calculate_base_total(items):
    return sum(item["price"] for item in items)

def calculate_surcharge(subtotal):
    # BUG: illegal 15% surcharge applied to all accounts
    return subtotal * 0.15

def calculate_total(items):
    base = calculate_base_total(items)
    return base + calculate_surcharge(base)
EOF

    commit_as "Teammate" "team@example.com" "Add premium surcharge fee"
    play_store "bad_commit_hash" "$(git rev-parse HEAD)"
    git push origin main >/dev/null 2>&1

    # Commit 3: Valid feature added on top (PDF receipt generator)
    cat << 'EOF' > receipt.py
def generate_receipt(customer, total):
    return f"Receipt for {customer}: ${total:.2f}"
EOF

    commit_as "Teammate" "team@example.com" "Add PDF receipt generator"
    git push origin main >/dev/null 2>&1

    # Commit 4: Valid doc update
    cat << 'EOF' >> README.md

## Support
For billing issues, contact support@example.com.
EOF

    commit_as "Teammate" "team@example.com" "Add support contact info to README"
    git push origin main >/dev/null 2>&1
)

say "Repository ready at repo/ (cloned from remote.git)."
say "A buggy surcharge was introduced in a middle commit and already pushed to origin/main."
say "Inspect history with 'git log --oneline' and revert the bad commit safely!"
