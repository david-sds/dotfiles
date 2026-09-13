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
  echo -e "${BLUE}[INFO]${NC} $msg!"
}

log_exists() {
  local msg=$1
  echo -e "${YELLOW}[WARN]${NC} $msg already exists." >&2
}

log_failed() {
  local msg=$1
  echo -e "${RED}[ERROR]${NC} $msg!" >&2
}

#------------------------------------------------------------------------------
# Installing .config directories
#------------------------------------------------------------------------------

printf '%s\n' "> Installing .config directories..."

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
  log_success "local script $script_name"
  ln -sfT "$script" "$installed_script"
done

mkdir -p "/usr/local/bin"
for script in "$DOTFILES"/bin/global/*; do
  script_name=$(basename $script)
  installed_script="/usr/local/bin/$script_name"
  if [ -L "$installed_script" ] && [ -e "$installed_script" ]; then
    log_exists "global script $script_name"
    continue
  fi
  log_success "global script $script_name"
  ln -sfT "$script" "$installed_script"
done

# -----------------------------------------------------------------------------
# Installing services
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing services..."

mkdir -p "$HOME/.config/systemd/user"
for service_file in "$DOTFILES"/service/local/*; do
  service_file_name=$(basename $service_file)
  installed_service_file="$HOME/.config/systemd/user/$service_file_name"
  if [ -L "$installed_service_file" ] && [ -e "$installed_service_file" ]; then
    log_exists "local service $service_file_name"
    continue
  fi
  log_success "local service $service_file_name"
  ln -sfT "$service_file" "$installed_service_file"
done

# -----------------------------------------------------------------------------
# Installing desktop files
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing desktop files..."

mkdir -p "$HOME/.local/share/applications/"
for desktop_file in "$DOTFILES"/desktop/local/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="$HOME/.local/share/applications/$desktop_file_name"
  if [ -L "$installed_desktop_file" ] && [ -e "$installed_desktop_file" ]; then
    log_exists "local desktop file $desktop_file_name"
    continue
  fi
  log_success "local desktop file $desktop_file_name"
  ln -sfT "$desktop_file" "$installed_desktop_file"
done

mkdir -p "/usr/share/applications/"
for desktop_file in "$DOTFILES"/desktop/global/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="/usr/share/applications/$desktop_file_name"
  if [ -L "$installed_desktop_file" ] && [ -e "$installed_desktop_file" ]; then
    log_exists "global desktop file $desktop_file_name"
    continue
  fi
  log_success "global desktop file $desktop_file_name"
  ln -sfT "$desktop_file" "$installed_desktop_file"
done

mkdir -p "$HOME/.local/share/xfce4/helpers"
for desktop_file in "$DOTFILES"/desktop/xfce4-helpers/*; do
  desktop_file_name=$(basename $desktop_file)
  installed_desktop_file="$HOME/.local/share/xfce4/helpers/$desktop_file_name"
  if [ -L "$installed_desktop_file" ] && [ -e "$installed_desktop_file" ]; then
    log_exists "xfce4 desktop helper file $desktop_file_name"
    continue
  fi
  log_success "xfce4 desktop helper file $desktop_file_name"
  ln -sfT "$desktop_file" "$installed_desktop_file"
done

printf '%s\n' "> Finished!"
