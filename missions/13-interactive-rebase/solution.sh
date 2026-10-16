# shellcheck shell=bash
# Mission 13 reference solution
# Automates the interactive rebase:
# - squashes 'Fix typo in avatar upload' into 'Add avatar upload feature'
# - drops 'Add temporary debug print'

cd "${SANDBOX}/repo" || exit 1

# Create an automated sequence editor script
editor_script="${SANDBOX}/.rebase_editor.sh"
cat << 'EOF' > "$editor_script"
#!/usr/bin/env bash
file="$1"
tmpf="${file}.tmp"
while IFS= read -r line; do
    if [[ "$line" =~ "Fix typo" ]]; then
        echo "squash ${line#pick }" >> "$tmpf"
    elif [[ "$line" =~ "temporary debug" ]]; then
        echo "drop ${line#pick }" >> "$tmpf"
    else
        echo "$line" >> "$tmpf"
    fi
done < "$file"
mv "$tmpf" "$file"
EOF
chmod +x "$editor_script"

# Run interactive rebase using automated sequence editor and non-interactive commit message editor
GIT_SEQUENCE_EDITOR="$editor_script" GIT_EDITOR="true" git rebase -i main >/dev/null 2>&1

rm -f "$editor_script"
