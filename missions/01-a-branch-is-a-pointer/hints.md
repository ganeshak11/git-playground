## Hint 1

When you run `git branch <name>`, Git creates a new branch pointer at your current commit (HEAD).
However, `git branch` can also take a second argument: a specific commit hash!

    git branch <branch-name> <commit-hash>

Look at `git log --oneline` to see the commit hashes in your history.

## Hint 2

You need to find the commit hashes for:
1. The second commit (one before HEAD): "Implement task list feature"
2. The first commit (the root): "Add basic project files"

Once you have those hashes (e.g. `abc1234` and `def5678`), run:

    git branch feature-v1 <second-commit-hash>
    git branch experimental <first-commit-hash>

Then, while on `main`, edit `README.md`, stage it with `git add`, and commit it with `git commit`.

## Hint 3

Here are the exact commands:

    cd repo
    git log --oneline

Note the hashes, or use Git's relative revision syntax:

    git branch feature-v1 HEAD~1
    git branch experimental HEAD~2

Now make the commit on `main`:

    echo "## Release Notes" >> README.md
    git add README.md
    git commit -m "Update documentation with release notes"

Verify by checking the contents of `.git/refs/heads/`:

    cat .git/refs/heads/main
    cat .git/refs/heads/feature-v1
    cat .git/refs/heads/experimental

Each file is just a 40-character commit hash!
