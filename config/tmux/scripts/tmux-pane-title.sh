#!/usr/bin/env bash

PANE="${1:-${TMUX_PANE:-}}"

CMD=$(tmux display -p -t "$PANE" '#{pane_current_command}')
TITLE=$(tmux display -p -t "$PANE" '#{pane_title}')

case "$CMD" in
claude)
  [[ "$TITLE" == "Claude: "* ]] && exit 0
  TITLE="Claude: $TITLE"
  ;;
*) exit 0 ;;
esac

tmux select-pane -t "$PANE" -T "$TITLE"
