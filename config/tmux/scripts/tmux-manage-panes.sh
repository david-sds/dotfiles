#!/usr/bin/env bash

TMUX_PANE_TITLE=${1:-"FZF tmux panes"}

NUM_PANES_RUNNING=$(tmux list-panes -a -F "#{pane_title}" | grep "$TMUX_PANE_TITLE" | wc -l)
if [[ "$NUM_PANES_RUNNING" -ge 2 ]]; then
  tmux display-message "A instance of '$TMUX_PANE_TITLE' already exists."
  exit 1
fi

LIST_PANES="tmux list-panes -a -F '(#{session_name}:#{window_index}.#{pane_index}) #{session_name}:#{window_name}.#{pane_title}' | grep -v '$TMUX_PANE_TITLE'"

TMUX_PANE=$(
  fzf --style full --layout reverse --delimiter '[()]' \
    --header "Enter: select   C-x: kill   C-y: copy" \
    --bind "start:reload($LIST_PANES)" \
    --bind "ctrl-x:execute-silent(tmux kill-pane -t {2})+reload($LIST_PANES)" \
    --bind "ctrl-y:execute-silent(bash ~/.config/tmux/scripts/tmux-copy.sh 'tmux {2}')" |
    sed 's/).*//; s/(//'
)

[[ -n "$TMUX_PANE" ]] && tmux switch-client -t "$TMUX_PANE"
