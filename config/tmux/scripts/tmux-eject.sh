#!/usr/bin/env bash

PANE="${1:-${TMUX_PANE:?provide a tmux pane}}"
TARGET="${2:-zip}"

TMP=$(tmux new-session -d -s "$TARGET" -P -F '#{window_id}' 2>/dev/null)
tmux switch-client -t "$TARGET"
WIN=$(tmux break-pane -s "$PANE" -t "$TARGET" -P -F '#{window_id}')
tmux select-window -t "$WIN"
[ -z "$TMP" ] || tmux kill-window -t "$TMP"
