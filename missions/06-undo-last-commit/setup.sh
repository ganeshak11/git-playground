# shellcheck shell=bash
# Mission 6 setup — sets up a repository with an initial clean commit,
# followed by an accidental, sloppy commit ("temp stuff whatever") that contains
# a good feature mixed with a broken draft line and incorrect debug setting.

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Clean initial commit
    cat << 'EOF' > README.md
# Payment Gateway
Stripe payment integration service.
EOF

    cat << 'EOF' > payment.py
def init_gateway():
    return "Gateway ready"
EOF

    cat << 'EOF' > settings.py
GATEWAY_URL = "https://api.stripe.com"
DEBUG = False
EOF

    commit_as "You" "you@example.com" "Initial payment gateway setup"

    # 2. Sloppy second commit (good feature + broken draft + wrong config)
    cat << 'EOF' > payment.py
def init_gateway():
    return "Gateway ready"

def process_stripe_payment(amount, token):
    return {"success": True, "charge_id": "ch_12345", "amount": amount}

# DRAFT BROKEN: send_email_receipt_v2()
EOF

    cat << 'EOF' > settings.py
GATEWAY_URL = "https://api.stripe.com"
DEBUG = True
EOF

    commit_as "You" "you@example.com" "temp stuff whatever"
)

say "Repository ready at repo/. A sloppy commit ('temp stuff whatever') was committed to main."
say "Inspect it with 'git log -1 --stat', then use 'git reset --soft HEAD~1' to undo it safely!"
