#!/usr/bin/env bash

YANKED=$1
if [ -e "$XDG_RUNTIME_DIR/wayland-0" ]; then
  printf %s "$YANKED" | wl-copy
else
  printf %s "$YANKED" | xclip -selection clipboard
fi

tmux display-message "Copied '$YANKED' !"
