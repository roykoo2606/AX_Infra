# agyx-autoboot.sh — sourced from ~/.zshrc
#
# Auto-launch agyx after a cmux restart. The agyx surface carries a
# CLI-set resume binding (kind=antigravity), but CLI bindings restore
# with auto_resume=false, so cmux itself never relaunches agy.
# Instead, when cmux restores the pane as a fresh interactive shell,
# this snippet detects the binding on the current surface and starts agyx.
#
# Marker setup (one-time, already done 2026-07-27):
#   cmux surface resume set --surface <agyx-surface> --kind antigravity \
#     --name agyx --cwd ~/Claude/Projects/AX_Infra -- ~/.local/bin/agyx

_agyx_autoboot() {
    # only inside cmux panes, once per shell tree
    [ -n "$CMUX_SURFACE_ID" ] || return 0
    [ -z "$AGYX_AUTOBOOT_DONE" ] || return 0
    export AGYX_AUTOBOOT_DONE=1
    command -v cmux >/dev/null 2>&1 || return 0

    kind=$(cmux surface resume get --json 2>/dev/null \
        | sed -n 's/.*"kind" *: *"\([^"]*\)".*/\1/p' | head -1)
    [ "$kind" = "antigravity" ] || return 0

    if [ -n "$AGYX_AUTOBOOT_DRYRUN" ]; then
        echo "[agyx-autoboot] would launch agyx (surface $CMUX_SURFACE_ID)"
        return 0
    fi
    echo "[agyx-autoboot] launching agyx..."
    /Users/roysmac/.local/bin/agyx
}
_agyx_autoboot
unset -f _agyx_autoboot
