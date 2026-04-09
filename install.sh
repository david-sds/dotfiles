#!/bin/bash

ln -sT "$(pwd)/alacritty" "$HOME/.config/alacritty"
ln -sT "$(pwd)/codex" "$HOME/.config/codex"
ln -sT "$(pwd)/nvim" "$HOME/.config/nvim"
ln -sT "$(pwd)/opencode" "$HOME/.config/opencode"
ln -sT "$(pwd)/tmux" "$HOME/.config/tmux"
ln -sT "$(pwd)/hypr" "$HOME/.config/hypr"
ln -sT "$(pwd)/walker" "$HOME/.config/walker"
ln -sT "$(pwd)/waybar" "$HOME/.config/waybar"
ln -sT "$(pwd)/mako" "$HOME/.config/mako"
ln -sT "$(pwd)/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

mkdir -p "$HOME/.local/bin"
ln -sT "$(pwd)/scripts/*" "$HOME/.local/bin/"
