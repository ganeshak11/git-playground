# shellcheck shell=bash
# Mission 15 setup — creates a bare remote and a clone where a feature branch
# (feature/export-csv) was pushed to origin, and then rewritten locally (via amend/rebase).
# Standard 'git push' is rejected with non-fast-forward.
# The learner must safely update origin using 'git push --force-with-lease'.

# 1. Create bare remote
make_bare_remote "remote.git"

# 2. Clone into working repository
git clone "${SANDBOX}/remote.git" "${SANDBOX}/repo" >/dev/null 2>&1

(
    cd "${SANDBOX}/repo"
    git config user.name "You"
    git config user.email "you@example.com"
    git config core.autocrlf false

    # Base commit on main
    cat << 'EOF' > README.md
# Analytics Report Service
Generates tabular data and report exports.
EOF

    cat << 'EOF' > report.py
def generate():
    return [{"id": 1, "metric": 42}]
EOF

    commit_as "You" "you@example.com" "Initial project setup"
    git push -u origin main >/dev/null 2>&1

    # Create feature branch and push initial version to origin
    git switch -c feature/export-csv >/dev/null 2>&1

    cat << 'EOF' > csv_exporter.py
def export_to_csv(data):
    # Initial export implementation
    return "id,metric\n1,42"
EOF

    commit_as "You" "you@example.com" "Add CSV export feature"
    git push -u origin feature/export-csv >/dev/null 2>&1

    # Now locally amend the commit to improve formatting and add UTF-8 header
    cat << 'EOF' > csv_exporter.py
def export_to_csv(data):
    # Formatted CSV with UTF-8 encoding
    header = "id,metric\n"
    rows = "".join(f"{d['id']},{d['metric']}\n" for d in data)
    return header + rows
EOF

    git add csv_exporter.py
    git commit --amend -m "Add CSV export feature with UTF-8 formatting" >/dev/null 2>&1
)

say "Repository ready at repo/ on branch 'feature/export-csv'."
say "You previously pushed this branch to origin, then amended/rewrote the commit locally."
say "Try running 'git push' to observe the non-fast-forward rejection."
say "Then update the remote safely using '--force-with-lease'!"
