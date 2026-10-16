# shellcheck shell=bash
# Solution for Mission 2: Look Before You Commit
# This is run by CI (via tests/run-all.sh) and shown to the learner via 'play solution'.

cd "${SANDBOX}/repo"

# Ensure local git identity is configured
git config user.name "You"
git config user.email "you@example.com"

# 1. Create .gitignore covering .env and *.log
cat << 'EOF' > .gitignore
.env
*.log
EOF

# 2. In server.js, remove the temporary debug line
grep -v "DEBUG" server.js > server.js.tmp && mv server.js.tmp server.js

# 3. Stage the files we actually want to commit
git add .gitignore config.js server.js

# 4. Commit clean production changes
git commit -m "Add health check endpoint, update config, and add gitignore"
