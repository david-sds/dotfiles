#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"
ln -sT "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
ln -sT "$SCRIPT_DIR/tmux" "$HOME/.config/tmux"
ln -sT "$SCRIPT_DIR/alacritty" "$HOME/.config/alacritty"
ln -sT "$SCRIPT_DIR/opencode" "$HOME/.config/opencode"
ln -sT "$SCRIPT_DIR/codex" "$HOME/.config/codex"

mkdir -p "$HOME/.local/bin"
for script in "$SCRIPT_DIR"/scripts/*; do
  if [ ! -f "$script" ] || [ ! -x "$script" ]; then
    continue
  fi
  ln -s "$script" "$HOME/.local/bin/"
done
