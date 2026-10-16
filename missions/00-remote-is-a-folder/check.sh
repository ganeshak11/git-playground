# shellcheck shell=bash
# Mission 0 check — verifies the learner created a bare remote and two clones.
# Checks outcomes, not commands: we verify hashes match, not what she typed.

# ── 1. team-remote.git must exist and be a bare repo ──
if [[ ! -d "${SANDBOX}/team-remote.git" ]]; then
    fail "No 'team-remote.git' directory found. You need to create a bare repository."
fi
assert_is_bare "${SANDBOX}/team-remote.git"

# ── 2. The remote must have at least one commit on main ──
remote_main="$(git -C "${SANDBOX}/team-remote.git" rev-parse refs/heads/main 2>/dev/null)" || {
    # Helpful message if they accidentally used 'master' instead of 'main'
    if git -C "${SANDBOX}/team-remote.git" rev-parse refs/heads/master >/dev/null 2>&1; then
        fail "The remote has a 'master' branch instead of 'main'. Recreate it with: git init --bare --initial-branch=main team-remote.git"
    fi
    fail "The remote has no branches yet. Create a file, commit it, and push."
}

# ── 3. Find all non-bare clones in the sandbox ──
clones=()
for d in "${SANDBOX}"/*/; do
    [[ -d "$d" ]] || continue
    dname="$(basename "$d")"
    # Skip hidden dirs (.play, .teammate-tmp) and the bare remote
    [[ "$dname" == .* ]] && continue
    [[ "$dname" == "team-remote.git" ]] && continue
    # Must be a non-bare git repo (has .git subdir)
    [[ -d "${d}.git" ]] || continue
    clones+=("$d")
done

if [[ ${#clones[@]} -lt 2 ]]; then
    fail "Expected at least 2 cloned repos in the sandbox, found ${#clones[@]}. Clone the remote a second time into a new directory."
fi

# ── 4. Each clone must be a clone of team-remote.git with matching HEAD ──
for clone_dir in "${clones[@]}"; do
    clone_name="$(basename "$clone_dir")"

    # Must have an 'origin' remote pointing to team-remote.git
    origin_url="$(git -C "$clone_dir" remote get-url origin 2>/dev/null)" \
        || fail "'$clone_name' has no 'origin' remote. Is it a clone of team-remote.git?"

    # Check by name (not full path) to avoid Windows path format mismatches
    if [[ "$origin_url" != *"team-remote.git"* ]]; then
        fail "'$clone_name' origin ($origin_url) doesn't point to team-remote.git."
    fi

    # HEAD must match the remote's main
    clone_head="$(git -C "$clone_dir" rev-parse HEAD 2>/dev/null)" \
        || fail "'$clone_name' has no commits."

    assert_refs_equal "$clone_head" "$clone_name HEAD" "$remote_main" "remote main"
done

pass "Two clones, one remote, all in sync. That's how git actually works!"
