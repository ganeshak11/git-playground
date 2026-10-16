## Hint 1

Run `git status` to see what is currently modified and untracked.
Then run `git diff server.js` to inspect the exact lines added to `server.js`.

You need to:
1. Ignore `.env` and `debug.log` using a `.gitignore` file.
2. Edit `server.js` to remove the temporary `console.log("DEBUG:...")` line while keeping `/health`.
3. Stage only `.gitignore`, `config.js`, and `server.js`.
4. Commit your clean work.

## Hint 2

To ignore `.env` and `debug.log`, create a file named `.gitignore` with these lines:
```
.env
*.log
```

Once created, run `git status`. You should see `.env` and `debug.log` disappear from the untracked files section!

Next, open `server.js` and delete the `console.log("DEBUG...")` line.
Run `git diff` to make sure only clean changes remain.

## Hint 3

Here are the exact commands:

```bash
cd repo

# 1. Create .gitignore
cat << 'EOF' > .gitignore
.env
*.log
EOF

# 2. Remove the debug line from server.js
# (You can edit it manually in your editor or use this filter):
grep -v "DEBUG" server.js > server.js.tmp && mv server.js.tmp server.js

# 3. Stage the files you want to commit
git add .gitignore config.js server.js

# 4. Review what is staged
git diff --staged

# 5. Commit
git commit -m "Add health check endpoint, update config, and add gitignore"
```
