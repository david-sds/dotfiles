#!/usr/bin/env bash

TMUX_PANE_TITLE=${1:-"FZF tmux panes"}

NUM_PANES_RUNNING=$(tmux list-panes -a -F "#{pane_title}" | grep "$TMUX_PANE_TITLE" | wc -l)
if [[ "$NUM_PANES_RUNNING" -ge 2 ]]; then
  tmux display-message "A instance of '$TMUX_PANE_TITLE' already exists."
  exit 1
fi

LIST_PANES="tmux list-panes -a -F '(#{session_name}:#{window_index}.#{pane_index}) #{session_name}:#{window_name}.#{pane_title}' | grep -v '$TMUX_PANE_TITLE'"

SWAP_MARKED="execute-silent(tmux swap-pane -d -s '{marked}' -t {2}; tmux select-pane -M)+reload-sync($LIST_PANES)"

TMUX_PANE=$(
  fzf --style full --layout reverse --delimiter '[()]' \
    --footer "Enter: select   C-x: kill   C-y: copy   C-M-n/j: move down   C-M-p/k: move up" \
    --bind "start:reload($LIST_PANES)" \
    --bind "ctrl-alt-n:execute-silent(tmux select-pane -m -t {2})+down+$SWAP_MARKED" \
    --bind "ctrl-alt-j:execute-silent(tmux select-pane -m -t {2})+down+$SWAP_MARKED" \
    --bind "ctrl-alt-p:execute-silent(tmux select-pane -m -t {2})+up+$SWAP_MARKED" \
    --bind "ctrl-alt-k:execute-silent(tmux select-pane -m -t {2})+up+$SWAP_MARKED" \
    --bind "ctrl-x:execute-silent(tmux kill-pane -t {2})+reload($LIST_PANES)" \
    --bind "ctrl-y:execute-silent(bash ~/.config/tmux/scripts/tmux-copy.sh 'tmux {2}')" |
    sed 's/).*//; s/(//'
)

[[ -n "$TMUX_PANE" ]] && tmux switch-client -t "$TMUX_PANE"
