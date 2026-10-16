## Hint 1

A **bare repository** is a git repo without a working tree — just the
internal database. Servers (and GitHub) use bare repos to store shared code.

Look at `git init --help`. There's a flag for creating bare repos, and
another for choosing the default branch name.

## Hint 2

Here's the rough sequence:

1. Create the bare repo with `git init --bare --initial-branch=main team-remote.git`
2. Clone from it: `git clone team-remote.git <some-name>`
3. Go into the clone, create a file, `git add` it, `git commit`, `git push`
4. Come back out and clone a second time into a different name

Don't forget to set your identity before committing:

    git config user.name "Your Name"
    git config user.email "you@example.com"

## Hint 3

The complete sequence:

    git init --bare --initial-branch=main team-remote.git
    git clone team-remote.git my-project
    cd my-project
    git config user.name "You"
    git config user.email "you@example.com"
    echo "# My Project" > README.md
    git add README.md
    git commit -m "First commit"
    git push origin main
    cd ..
    git clone team-remote.git teammate-clone

After this, look inside `team-remote.git/` — no source files, just git internals.
Both `my-project/` and `teammate-clone/` have the same commit.
