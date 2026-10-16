# shellcheck shell=bash
# Mission 17 setup — simulates an accidental direct push of broken experimental code
# to origin/main.
# The learner must:
# 1. Rescue the experimental work onto feature/payment-gateway.
# 2. Revert the broken commit on main and push to origin/main.
# 3. Write a post-mortem incident report in INCIDENT.md.

# 1. Create bare remote
make_bare_remote "remote.git"

# 2. Clone into working repository
git clone "${SANDBOX}/remote.git" "${SANDBOX}/repo" >/dev/null 2>&1

(
    cd "${SANDBOX}/repo" || exit 1
    git config user.name "You"
    git config user.email "you@example.com"
    git config core.autocrlf false

    # Base stable commit on main
    cat << 'EOF' > README.md
# Core Platform
Production platform service.
EOF

    cat << 'EOF' > app.py
def run():
    return "Application running smoothly"
EOF

    commit_as "Teammate" "team@example.com" "Initial stable platform setup"
    git push -u origin main >/dev/null 2>&1

    # Accidental direct commit and push on main!
    cat << 'EOF' > gateway.py
# BROKEN WIP: Unfinished experimental gateway - crashes application!
def process_payment(amount):
    raise NotImplementedError("Payment gateway not configured!")
EOF

    commit_as "You" "you@example.com" "WIP: experimental payment gateway"
    play_store "wip_commit_hash" "$(git rev-parse HEAD)"
    git push origin main >/dev/null 2>&1
)

say "ALERT: You accidentally pushed broken experimental code directly to origin/main!"
say "CI builds are failing across the team."
say "1. Rescue your work to branch 'feature/payment-gateway'."
say "2. Revert the bad commit on main and push the fix to origin/main."
say "3. Document the incident and prevention in 'INCIDENT.md'."
