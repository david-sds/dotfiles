#!/usr/bin/env bash

YANKED=$1

if ls -d $XDG_RUNTIME_DIR/wayland-* &>/dev/null; then
  printf %s "$YANKED" | wl-copy
else
  printf %s "$YANKED" | xclip -selection clipboard
fi

tmux display-message "Copied '$YANKED' !"
