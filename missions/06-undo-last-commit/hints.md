## Hint 1

To undo the last commit without losing your code, run:

    git reset --soft HEAD~1

This moves `HEAD` back to the parent commit, but keeps all your modifications staged in the Staging Area.
Check `git status` after running it — you will see your files ready to be adjusted!

## Hint 2

After running `git reset --soft HEAD~1`:
1. In `payment.py`: remove the line `# DRAFT BROKEN: send_email_receipt_v2()`.
2. In `settings.py`: change `DEBUG = True` to `DEBUG = False`.
3. Stage both files with `git add payment.py settings.py`.
4. Commit with a clean message: `git commit -m "Implement Stripe payment processing and configure production settings"`.

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Soft reset moves HEAD back 1 commit, keeping files staged
git reset --soft HEAD~1

# 2. Fix payment.py
cat << 'EOF' > payment.py
def init_gateway():
    return "Gateway ready"

def process_stripe_payment(amount, token):
    return {"success": True, "charge_id": "ch_12345", "amount": amount}
EOF

# 3. Fix settings.py
cat << 'EOF' > settings.py
GATEWAY_URL = "https://api.stripe.com"
DEBUG = False
EOF

# 4. Stage and commit
git add payment.py settings.py
git commit -m "Implement Stripe payment processing and configure production settings"
```
