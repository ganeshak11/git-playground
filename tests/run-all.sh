#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PLAY="${SCRIPT_DIR}/../play"
SANDBOX_ROOT="$(mktemp -d)"
export GIT_PLAYGROUND_SANDBOX="$SANDBOX_ROOT"

# Ensure cleanup on exit
cleanup() { rm -rf "$SANDBOX_ROOT"; }
trap cleanup EXIT

# Source common.sh only for lib functions used by solution.sh (via source).
# The play CLI itself is run as a subprocess.
PLAY_ROOT="${SCRIPT_DIR}/.."
source "${PLAY_ROOT}/lib/common.sh"
source "${PLAY_ROOT}/lib/repo.sh"
source "${PLAY_ROOT}/lib/assert.sh"

passed=0
failed=0
errors=()

for mission_dir in "${SCRIPT_DIR}"/../missions/*/; do
    [[ -d "$mission_dir" ]] || continue

    dir_name="$(basename "$mission_dir")"
    mission_num="${dir_name%%-*}"
    n=$((10#$mission_num))

    echo ""
    echo "=== Testing Mission $n: $dir_name ==="

    # ── Step 1: start, then check must FAIL ──
    echo "  > Starting mission $n..."
    if ! start_output="$("$PLAY" start "$n" 2>&1)"; then
        echo "  FAIL: 'play start $n' crashed"
        echo "$start_output"
        failed=$((failed + 1))
        errors+=("Mission $n: start failed")
        continue
    fi

    echo "  > Verifying check fails before solution..."
    if check_output="$("$PLAY" check 2>&1)"; then
        echo "  FAIL: check passed BEFORE solution was applied"
        echo "$check_output"
        failed=$((failed + 1))
        errors+=("Mission $n: check passed before solution")
        continue
    fi
    echo "  OK: check correctly fails"

    # ── Step 2: run solution in a SUBSHELL, then check must PASS ──
    # Subshell prevents solution.sh from changing the runner's cwd.
    echo "  > Running solution..."
    SANDBOX="${SANDBOX_ROOT}/${mission_num}"
    export SANDBOX
    if ! solution_output="$(
        cd "$SANDBOX" || exit 1
        # shellcheck source=/dev/null
        source "${mission_dir}/solution.sh" 2>&1
    )"; then
        echo "  FAIL: solution.sh crashed"
        echo "$solution_output"
        failed=$((failed + 1))
        errors+=("Mission $n: solution failed")
        continue
    fi

    echo "  > Verifying check passes after solution..."
    if ! check_output="$("$PLAY" check 2>&1)"; then
        echo "  FAIL: check failed AFTER solution was applied"
        echo "$check_output"
        failed=$((failed + 1))
        errors+=("Mission $n: check failed after solution")
        continue
    fi
    echo "  OK: check correctly passes"

    # ── Step 3: reset, then check must FAIL again ──
    echo "  > Resetting..."
    if ! reset_output="$("$PLAY" reset 2>&1)"; then
        echo "  FAIL: 'play reset' crashed"
        echo "$reset_output"
        failed=$((failed + 1))
        errors+=("Mission $n: reset failed")
        continue
    fi

    echo "  > Verifying check fails after reset..."
    if check_output="$("$PLAY" check 2>&1)"; then
        echo "  FAIL: check passed AFTER reset"
        echo "$check_output"
        failed=$((failed + 1))
        errors+=("Mission $n: check passed after reset")
        continue
    fi
    echo "  OK: check correctly fails after reset"

    passed=$((passed + 1))
    echo "  Mission $n: ALL PASSED"
done

echo ""
echo "======================================="
echo "  Passed: $passed"
echo "  Failed: $failed"

if [[ ${#errors[@]} -gt 0 ]]; then
    echo ""
    echo "  Failures:"
    for err in "${errors[@]}"; do
        echo "    !! $err"
    done
    exit 1
fi

echo ""
echo "  All tests passed!"
