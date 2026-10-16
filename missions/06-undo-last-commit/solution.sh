# shellcheck shell=bash
# Solution for Mission 6: Undo the Last Commit
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Undo the sloppy commit while preserving changes in staging
git reset --soft HEAD~1

# 2. Fix payment.py (keep process_stripe_payment, remove broken draft line)
cat << 'EOF' > payment.py
def init_gateway():
    return "Gateway ready"

def process_stripe_payment(amount, token):
    return {"success": True, "charge_id": "ch_12345", "amount": amount}
EOF

# 3. Fix settings.py (set DEBUG = False)
cat << 'EOF' > settings.py
GATEWAY_URL = "https://api.stripe.com"
DEBUG = False
EOF

# 4. Stage the corrected files
git add payment.py settings.py

# 5. Record the clean commit
git commit -m "Implement Stripe payment processing and configure production settings"
