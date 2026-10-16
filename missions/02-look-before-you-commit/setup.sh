# shellcheck shell=bash
# Mission 2 setup — builds a repository with an initial commit,
# then creates uncommitted edits (config + debug code) and untracked files (.env + debug.log).

make_repo "repo"

(
    cd "${SANDBOX}/repo"

    # 1. Baseline files
    cat << 'EOF' > README.md
# Task API
A simple task management backend service.
EOF

    cat << 'EOF' > config.js
const PORT = 3000;

module.exports = { PORT };
EOF

    cat << 'EOF' > server.js
const http = require('http');
const config = require('./config');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Task API Running');
});

server.listen(config.PORT);
EOF

    commit_as "You" "you@example.com" "Initial server setup"
    play_store "initial_commit" "$(git rev-parse HEAD)"

    # 2. Modify config.js (legitimate configuration addition)
    cat << 'EOF' > config.js
const PORT = 3000;
const TIMEOUT = 5000;

module.exports = { PORT, TIMEOUT };
EOF

    # 3. Modify server.js (health check feature + accidental debug code)
    cat << 'EOF' > server.js
const http = require('http');
const config = require('./config');

const server = http.createServer((req, res) => {
  console.log("DEBUG: Incoming request to " + req.url); // TEMPORARY DEBUGGING - DO NOT COMMIT!
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Task API Running');
});

server.listen(config.PORT);
EOF

    # 4. Create secret .env file (must NOT be committed!)
    cat << 'EOF' > .env
API_SECRET_KEY=super-secret-token-xyz-123
DB_PASSWORD=production-password-never-share
EOF

    # 5. Create temporary debug log file (must NOT be committed!)
    cat << 'EOF' > debug.log
[2026-10-16 00:00:01] INFO Server starting...
[2026-10-16 00:00:02] DEBUG Listening on port 3000
[2026-10-16 00:00:03] DEBUG Memory usage: 42MB
EOF
)

say "Repository initialized at repo/ with uncommitted edits and untracked files."
say "Run 'git status' and 'git diff' to inspect the state before touching anything!"
