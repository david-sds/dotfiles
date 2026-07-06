#!/usr/bin/env bash

SESSION="$1"
WINDOW="$2"
PANE="$3"
FLOAT_WIN_NAME='floating'

if [ "$(tmux display-message -p '#{pane_floating_flag}')" = "1" ]; then
  if ! tmux list-windows -t "$SESSION" | grep -q "$FLOAT_WIN_NAME"; then
    tmux new-window -t "$SESSION:" -n "$FLOAT_WIN_NAME" -d
  fi
  tmux swap-pane -s "$PANE" -t "$SESSION:$FLOAT_WIN_NAME" -d
  tmux kill-pane -t "$SESSION:$WINDOW.$PANE"
else
  NEW_PANE_INDEX=$(tmux new-pane \
    -x "#{e|*|f|0:#{client_width},0.8}" \
    -y "#{e|*|f|0:#{client_height},0.8}" \
    -X "#{e|*|f|0:#{client_width},0.1}" \
    -Y "#{e|*|f|0:#{client_height},0.1}" \
    -S "fg=blue" \
    -R "fg=red" \
    -P -F '#{pane_index}')

  OTHER_FLOAT=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} #{pane_floating_flag}' |
    awk -v new="$SESSION:$WINDOW.$NEW_PANE_INDEX" '$2==1 && $1!=new {print $1; exit}')

  if [ -n "$OTHER_FLOAT" ]; then
    tmux swap-pane -s "$OTHER_FLOAT" -t "$SESSION:$WINDOW.$NEW_PANE_INDEX"
    tmux kill-pane -t "$OTHER_FLOAT"
  elif tmux list-windows -t "$SESSION" | grep -q "$FLOAT_WIN_NAME"; then
    tmux swap-pane -s "$SESSION:$FLOAT_WIN_NAME.1" -t "$SESSION:$WINDOW.$NEW_PANE"
    tmux kill-window -t "$SESSION:$FLOAT_WIN_NAME"
  fi
fi
