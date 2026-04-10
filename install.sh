#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config"
ln -sT "$SCRIPT_DIR/nvim" "$HOME/.config/nvim"
ln -sT "$SCRIPT_DIR/tmux" "$HOME/.config/tmux"
ln -sT "$SCRIPT_DIR/alacritty" "$HOME/.config/alacritty"
ln -sT "$SCRIPT_DIR/opencode" "$HOME/.config/opencode"
ln -sT "$SCRIPT_DIR/codex" "$HOME/.config/codex"
ln -sT "$SCRIPT_DIR/hypr" "$HOME/.config/hypr"
ln -sT "$SCRIPT_DIR/walker" "$HOME/.config/walker"
ln -sT "$SCRIPT_DIR/waybar" "$HOME/.config/waybar"
ln -sT "$SCRIPT_DIR/mako" "$HOME/.config/mako"
ln -sT "$SCRIPT_DIR/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

mkdir -p "$HOME/.local/bin"
for script in "$SCRIPT_DIR"/scripts/*; do
  if [ ! -f "$script" ] || [ ! -x "$script" ]; then
    continue
  fi
  ln -s "$script" "$HOME/.local/bin/"
done
