#!/usr/bin/env bash

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

success=()
exists=()
failed=()

#------------------------------------------------------------------------------
# Install .config directories
#------------------------------------------------------------------------------

mkdir -p "$HOME/.config"
configs=(
  "nvim"
  "tmux"
  "alacritty"
  "opencode"
  "codex"
  "hypr"
  "walker"
  "quickshell"
  "mako"
  "xdg-desktop-portal"
  "lazygit"
  "satty"
  "zathura"
  "btop"
  "xfce4"
  "imv"
)
for config in "${configs[@]}"; do
  config_path="$DOTFILES/configs/$config"

  if [ ! -e "$config_path" ]; then
    failed+=("$config:source not found: $config_path")
    continue
  fi

  err=$(ln -sT "$config_path" "$HOME/.config/$config" 2>&1)
  status=$?

  if [ $status -eq 0 ]; then
    success+=("$config config")
  else
    if echo "$err" | grep -qi "exists"; then
      exists+=("$config config")
    else
      failed+=("$config:$err")
    fi
  fi
done

# -----------------------------------------------------------------------------
# Install local and global scripts
# -----------------------------------------------------------------------------

mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES"/scripts/local/*; do
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
for script in "$DOTFILES"/scripts/global/*; do
  script_name=$(basename $script)
  installed_script="/usr/local/bin/$script_name"
  if [ -x "$installed_script" ]; then
    exists+=("global script $script_name")
    continue
  fi
  success+=("global script $script_name")
  ln -s "$script" "$installed_script"
done

# -----------------------------------------------------------------------------
# Install desktop files
# -----------------------------------------------------------------------------

mkdir -p "$HOME/.local/share/applications/"
for desktop_file in "$DOTFILES"/desktop-files/local/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="$HOME/.local/share/applications/$desktop_file_name"
  if [ -e "$installed_desktop_file" ]; then
    exists+=("local desktop_file $desktop_file_name")
    continue
  fi
  success+=("local desktop_file $desktop_file_name")
  ln -s "$desktop_file" "$installed_desktop_file"
done

mkdir -p "/usr/share/applications/"
for desktop_file in "$DOTFILES"/desktop-files/global/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="/usr/share/applications/$desktop_file_name"
  if [ -e "$installed_desktop_file" ]; then
    exists+=("global desktop_file $desktop_file_name")
    continue
  fi
  success+=("global desktop_file $desktop_file_name")
  ln -s "$desktop_file" "$installed_desktop_file"
done

mkdir -p "$HOME/.local/share/xfce4/helpers"
for desktop_file in "$DOTFILES"/desktop-files/xfce4-helpers/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="$HOME/.local/share/xfce4/helpers/$desktop_file_name"
  if [ -e "$installed_desktop_file" ]; then
    exists+=("global desktop_file $desktop_file_name")
    continue
  fi
  success+=("global desktop_file $desktop_file_name")
  ln -s "$desktop_file" "$installed_desktop_file"
done

# -----------------------------------------------------------------------------
# Log the results
# -----------------------------------------------------------------------------

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
  echo -e "${RED}[ERROR]${NC} $c!" >&2
done
