#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

success=()
exists=()
failed=()

mkdir -p "$HOME/.config"
configs=(
  "alacritty"
  # "btop"
  "hypr"
  "lazygit"
  "nvim"
  # "opencode"
  "tmux"
  "omarchy"
  # "zathura"
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
for script in "$SCRIPT_DIR"/scripts/local/*; do
  script_name=$(basename $script)
  installed_script="$HOME/.local/bin/$script_name"
  if [ -x "$installed_script" ]; then
    exists+=("local script $script_name")
    continue
  fi
  success+=("local script $script_name")
  ln -s "$script" "$installed_script"
done

mkdir -p "/usr/local/bin"
for script in "$SCRIPT_DIR"/scripts/global/*; do
  script_name=$(basename $script)
  installed_script="/usr/local/bin/$script_name"
  if [ -x "$installed_script" ]; then
    exists+=("global script $script_name")
    continue
  fi
  success+=("global script $script_name")
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
