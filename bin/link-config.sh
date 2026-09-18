#!/usr/bin/env bash

shopt -s nullglob

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/.."

# -----------------------------------------------------------------------------
# Logs
# -----------------------------------------------------------------------------

RED='\e[0;31m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
NC='\e[0m'

log_success() {
  local msg=$1
  echo -e "${BLUE}[INFO]${NC} $msg was linked successfully!"
}

log_exists() {
  local msg=$1
  echo -e "${YELLOW}[WARN]${NC} $msg already exists." >&2
}

log_failed() {
  local msg=$1
  echo -e "${RED}[ERROR]${NC} $msg" >&2
}

#------------------------------------------------------------------------------
# Installing .config directories
#------------------------------------------------------------------------------

printf '%s\n' "> Installing .config directories..."

mkdir -p "$HOME/.config"
configs=(
  "alacritty"
  "codex"
  "lazygit"
  "nvim"
  "opencode"
  "tmux"
)
for config in "${configs[@]}"; do
  config_path="$DOTFILES/config/$config"

  if [ ! -e "$config_path" ]; then
    log_failed "$config:source not found: $config_path"
    continue
  fi

  target_config="$HOME/.config/$config"
  if [ -L "$target_config" ] && [ -e "$target_config" ]; then
    log_exists "$config config"
    continue
  fi

  err=$(ln -sfT "$config_path" "$target_config" 2>&1)
  status=$?

  if [ $status -eq 0 ]; then
    log_success "$config config"
  else
    if echo "$err" | grep -qi "exists"; then
      log_exists "$config config"
    else
      log_failed "$config:$err"
    fi
  fi
done

# -----------------------------------------------------------------------------
# Installing local and global scripts
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing local and global scripts..."

mkdir -p "$HOME/.local/bin"
for script in "$DOTFILES"/bin/local/*; do
  script_name=$(basename $script)
  installed_script="$HOME/.local/bin/$script_name"
  if [ -L "$installed_script" ] && [ -e "$installed_script" ]; then
    log_exists "local script $script_name"
    continue
  fi

  err=$(ln -sfT "$script" "$installed_script" 2>&1)
  status=$?

  if [ $status -eq 0 ]; then
    log_success "local script $script_name"
  else
    log_failed "local script $script_name:$err"
  fi
done

mkdir -p "/usr/local/bin"
for script in "$DOTFILES"/bin/global/*; do
  script_name=$(basename $script)
  installed_script="/usr/local/bin/$script_name"
  if [ -L "$installed_script" ] && [ -e "$installed_script" ]; then
    log_exists "global script $script_name"
    continue
  fi

  err=$(ln -sfT "$script" "$installed_script" 2>&1)
  status=$?

  if [ $status -eq 0 ]; then
    log_success "global script $script_name"
  else
    log_failed "global script $script_name:$err"
  fi
done

printf '%s\n' "> Finished!"
