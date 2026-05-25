#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

success=()
exists=()
failed=()

mkdir -p "$HOME/.config"
configs=("nvim"
  "tmux"
  "alacritty"
  "opencode"
  "codex"
  "hypr"
  "walker"
  "waybar"
  "quickshell"
  "mako"
  "xdg-desktop-portal"
  "lazygit"
  "satty"
  "zathura"
  "btop"
)
for config in "${configs[@]}"; do
  err=$(ln -sT "$SCRIPT_DIR/$config" "$HOME/.config/$config" 2>&1)
  status=$?

  if [ $status -eq 0 ]; then
    success+=("$config")
  else
    if echo "$err" | grep -qi "exists"; then
      exists+=("$config")
    else
      failed+=("$config:$err")
    fi
  fi
done

mkdir -p "$HOME/.local/bin"
for script in "$SCRIPT_DIR"/scripts/*; do
  installed_script="$HOME/.local/bin/$script"
  if [ ! -f "$installed_script" ] || [ ! -x "$installed_script" ]; then
    continue
  fi
  ln -s "$script" "$installed_script"
done

RED='\e[0;31m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
NC='\e[0m'
for c in "${success[@]}"; do
  echo -e "${BLUE}[INFO]${NC} $c installed!"
done

for c in "${exists[@]}"; do
  echo -e "${YELLOW}[WARN]${NC} $c already exists." >&2
done

for c in "${failed[@]}"; do
  echo -e "${RED}[ERROR]${NC} $c failed!" >&2
done
