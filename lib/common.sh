# shellcheck shell=bash
# lib/common.sh — output helpers, path resolution, state management
#
# Dependencies: PLAY_ROOT must be set before sourcing this file.

# ── Unicode / ASCII fallback ─────────────────────────────────────
# Auto-enable ASCII on Windows consoles outside mintty, where ✓ ▸ ─ garble.
if [[ "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]]; then
    if [[ "${TERM_PROGRAM:-}" != "mintty" ]]; then
        PLAY_ASCII="${PLAY_ASCII:-1}"
    fi
fi

if [[ "${PLAY_ASCII:-0}" == "1" ]]; then
    _SYM_PASS="[OK]"
    _SYM_FAIL="[!!]"
    _SYM_ARROW=">"
    _SYM_INFO="[i]"
    _SYM_WARN="[!]"
else
    _SYM_PASS="✓"
    _SYM_FAIL="✗"
    _SYM_ARROW="▸"
    _SYM_INFO="ℹ"
    _SYM_WARN="⚠"
fi

# ── Colors (only when stdout is a terminal) ──────────────────────
if [[ -t 1 ]]; then
    RED=$'\033[0;31m'
    GREEN=$'\033[0;32m'
    YELLOW=$'\033[0;33m'
    BLUE=$'\033[0;34m'
    BOLD=$'\033[1m'
    DIM=$'\033[2m'
    RESET=$'\033[0m'
else
    RED="" GREEN="" YELLOW="" BLUE="" BOLD="" DIM="" RESET=""
fi

# ── Output functions ─────────────────────────────────────────────
say()    { echo "${GREEN}${_SYM_ARROW}${RESET} $*"; }
info()   { echo "${BLUE}${_SYM_INFO}${RESET} $*"; }
warn()   { echo "${YELLOW}${_SYM_WARN}${RESET} $*" >&2; }
fail()   { echo "${RED}${_SYM_FAIL}${RESET} $*" >&2; exit 1; }
pass()   { echo "${GREEN}${_SYM_PASS}${RESET} $*"; }

hr() {
    if [[ "${PLAY_ASCII:-0}" == "1" ]]; then
        printf -- '-%.0s' {1..60}
        echo
    else
        echo -n "${DIM}"
        printf '─%.0s' {1..60}
        echo "${RESET}"
    fi
}

header() {
    hr
    echo "${BOLD}$*${RESET}"
    hr
}

# ── Path helpers ─────────────────────────────────────────────────

# Resolve a path to absolute, following symlinks (pwd -P, not readlink -f).
# Returns 1 if the path doesn't exist.
resolve_path() {
    if [[ ! -d "$1" ]]; then
        echo "$1"
        return 1
    fi
    (cd "$1" && pwd -P)
}

# Check if $1 is safely inside $2 (both must exist as directories).
is_inside() {
    local child parent
    child="$(cd "$1" 2>/dev/null && pwd -P)" || return 1
    parent="$(cd "$2" 2>/dev/null && pwd -P)" || return 1
    [[ "$child" == "$parent"/* ]]
}

# Check if a mission exists.
mission_exists() {
    local n="$1"
    local padded
    padded="$(printf '%02d' "$n")"
    local matches=("${PLAY_ROOT}/missions/${padded}-"*/)
    [[ -d "${matches[0]:-}" ]]
}

# Get the mission directory path for a given mission number.
# Uses a bash glob instead of `find` — Windows' find.exe is a different tool.
mission_dir_for() {
    local n="$1"
    local padded
    padded="$(printf '%02d' "$n")"
    local matches=("${PLAY_ROOT}/missions/${padded}-"*/)
    if [[ ! -d "${matches[0]:-}" ]]; then
        fail "Mission $n not found."
    fi
    # Remove trailing slash
    echo "${matches[0]%/}"
}

# ── State management ─────────────────────────────────────────────
# State lives in $SANDBOX_ROOT/.play-state as KEY=VALUE lines.
# Avoids sed -i (GNU vs BSD differ) — uses temp file + mv.

_ensure_state_file() {
    mkdir -p "$(dirname "$PLAY_STATE_FILE")"
    touch "$PLAY_STATE_FILE"
}

state_get() {
    local key="$1"
    _ensure_state_file
    # grep under set -e + pipefail: || true prevents exit on missing key
    local line
    line="$(grep "^${key}=" "$PLAY_STATE_FILE" 2>/dev/null || true)"
    if [[ -n "$line" ]]; then
        echo "${line#*=}"
    fi
}

state_set() {
    local key="$1" value="$2"
    _ensure_state_file
    grep -v "^${key}=" "$PLAY_STATE_FILE" > "${PLAY_STATE_FILE}.tmp" 2>/dev/null || true
    echo "${key}=${value}" >> "${PLAY_STATE_FILE}.tmp"
    mv "${PLAY_STATE_FILE}.tmp" "$PLAY_STATE_FILE"
}

state_has() {
    local key="$1"
    _ensure_state_file
    grep -q "^${key}=" "$PLAY_STATE_FILE" 2>/dev/null
}

# ── Safe deletion ────────────────────────────────────────────────

safe_delete() {
    local target="$1"

    # Guard: SANDBOX_ROOT must be set and sane
    if [[ -z "${SANDBOX_ROOT:-}" ]]; then
        fail "SANDBOX_ROOT is not set. This is a bug."
    fi

    # Resolve SANDBOX_ROOT — if it doesn't exist yet, nothing to delete
    if [[ ! -d "$SANDBOX_ROOT" ]]; then
        return 0
    fi

    local resolved_root
    resolved_root="$(cd "$SANDBOX_ROOT" && pwd -P)" \
        || fail "Cannot resolve SANDBOX_ROOT ($SANDBOX_ROOT)."

    # Guard against catastrophic paths
    if [[ "$resolved_root" == "/" ]]; then
        fail "SANDBOX_ROOT must not be /. Set GIT_PLAYGROUND_SANDBOX."
    fi
    if [[ "$resolved_root" == "$HOME" ]]; then
        fail "SANDBOX_ROOT must not be \$HOME. Set GIT_PLAYGROUND_SANDBOX."
    fi

    # If target doesn't exist, nothing to do
    if [[ ! -d "$target" ]]; then
        return 0
    fi

    local resolved_target
    resolved_target="$(cd "$target" && pwd -P)" \
        || fail "Cannot resolve path: $target"

    if [[ "$resolved_target" != "$resolved_root"/* ]]; then
        fail "Refusing to delete '$target' — it is not inside the sandbox ($SANDBOX_ROOT)."
    fi

    rm -rf "$target"
}

# ── Require active mission ───────────────────────────────────────

require_active_mission() {
    if ! state_has current_mission; then
        fail "No active mission. Run 'play start N' first."
    fi
    state_get current_mission
}
