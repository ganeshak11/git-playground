## Hint 1

When you run `git pull origin main`, Git pauses with `CONFLICT (content): Merge conflict in app.py`.

Open `app.py`. Git placed conflict markers around the disputed lines:
- `<<<<<<< HEAD` marks your local version (`MAX_ITEMS_PER_PAGE = 50`).
- `=======` is the divider.
- `>>>>>>> ...` marks Jordan's incoming version (`MAX_ITEMS_PER_PAGE = 100`).

You must edit `app.py` directly to choose the right code and delete all marker lines.

## Hint 2

The team agreed on using Jordan's value of `100`.
In `app.py`, delete the `<<<<<<< HEAD`, `=======`, and `>>>>>>> ...` lines, as well as the `MAX_ITEMS_PER_PAGE = 50` line.

Keep only:
```python
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets
```

After saving `app.py`, run `git add app.py` to tell Git the conflict is resolved.

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Trigger the conflict if you haven't yet
git pull origin main

# 2. Open app.py in your editor, or overwrite it with the clean resolved version:
cat << 'EOF' > app.py
# Task Tracker API

API_VERSION = "1.0"
APP_NAME = "TaskApp"
MAX_ITEMS_PER_PAGE = 100  # Updated by Jordan for large datasets

def get_status():
    return {"status": "ok", "version": API_VERSION}
EOF

# 3. Mark the conflict as resolved
git add app.py

# 4. Finalize the merge commit
git commit -m "Resolve pagination conflict by setting limit to 100"

# 5. Push to remote
git push origin main
```
