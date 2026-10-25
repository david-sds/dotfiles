#!/usr/bin/env bash

TMUX_PANE_TITLE=${1:-"FZF tmux panes"}

NUM_PANES_RUNNING=$(tmux list-panes -a -F "#{pane_title}" | grep "$TMUX_PANE_TITLE" | wc -l)
if [[ "$NUM_PANES_RUNNING" -ge 2 ]]; then
  tmux display-message "A instance of '$TMUX_PANE_TITLE' already exists."
  exit 1
fi

TMUX_PANE=$(
  tmux list-panes -a \
    -F "(#{session_name}:#{window_index}.#{pane_index}) #{session_name}:#{window_name}.#{pane_title}" |
    grep -v "$TMUX_PANE_TITLE" |
    fzf --style full --layout reverse |
    sed 's/).*//; s/(//'
)

tmux switch-client -t "$TMUX_PANE"
