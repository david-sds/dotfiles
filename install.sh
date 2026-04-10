#!/bin/bash

mkdir -p "$HOME/.config"
ln -sT "$(pwd)/nvim" "$HOME/.config/nvim"
ln -sT "$(pwd)/tmux" "$HOME/.config/tmux"
ln -sT "$(pwd)/alacritty" "$HOME/.config/alacritty"
ln -sT "$(pwd)/opencode" "$HOME/.config/opencode"
ln -sT "$(pwd)/codex" "$HOME/.config/codex"
ln -sT "$(pwd)/autostart" "$HOME/.config/autostart"

mkdir -p "$HOME/.local/bin"
for script in "$SCRIPT_DIR"/scripts/*; do
  if [ ! -f "$script" ] || [ ! -x "$script" ]; then
    continue
  fi
  ln -s "$script" "$HOME/.local/bin/"
done
