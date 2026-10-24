#!/usr/bin/env bash

shopt -s nullglob

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/.."

# -----------------------------------------------------------------------------
# Utils
# -----------------------------------------------------------------------------

RED='\e[0;31m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
NC='\e[0m'

log_success() {
  local msg=$1
  echo -e "${BLUE}[INFO]${NC} $msg"
}

log_exists() {
  local msg=$1
  echo -e "${YELLOW}[WARN]${NC} $msg" >&2
}

log_failed() {
  local msg=$1
  echo -e "${RED}[ERROR]${NC} $msg" >&2
}

remove_broken_links() {
  local target_dir=$1
  [ -d "$target_dir" ] || return
  for link in $(find "$target_dir" -maxdepth 1 -type l ! -exec test -e {} \; -print 2>&1); do
    link_name=$(basename "$link")
    err=$(rm -f "$link" 2>&1)
    status=$?
    if [ $status -eq 0 ]; then
      log_success "broken link $link_name removed successfully!"
    else
      log_failed "cannot remove broken link $link_name:\n$err"
    fi
  done
}

handle_links_list() {
  local orig_dir=$1 dest_dir=$2 template=${3:-%s}
  local -n list=$4

  mkdir -p "$dest_dir"
  remove_broken_links "$dest_dir"

  for target in "${list[@]}"; do
    orig_path="$orig_dir/$target"
    local target_label=$(printf -- "$template" "$target")

    if [ ! -e "$orig_path" ]; then
      log_failed "$target_label:source not found: $orig_path"
      continue
    fi

    dest_path="$dest_dir/$target"
    if [ -L "$dest_path" ] && [ -e "$dest_path" ]; then
      log_exists "$target_label already exists."
      continue
    fi

    err=$(ln -sfT "$orig_path" "$dest_path" 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
      log_success "$target_label was linked successfully!"
    else
      if echo "$err" | grep -qi "exists"; then
        log_exists "$target_label already exists."
      else
        log_failed "$target_label:$err"
      fi
    fi
  done
}

handle_links() {
  local orig_dir=$1 dest_dir=$2 template=${3:-%s}

  mkdir -p "$dest_dir"
  remove_broken_links "$dest_dir"

  for orig in "$orig_dir"/*; do
    local orig_name=$(basename $orig)
    local orig_link="$dest_dir/$orig_name"
    local subject=$(printf -- "$template" "$orig_name")

    if [ -L "$orig_link" ] && [ -e "$orig_link" ]; then
      log_exists "$subject already exists."
      continue
    fi

    err=$(ln -sfT "$orig" "$orig_link" 2>&1)
    status=$?

    if [ $status -eq 0 ]; then
      log_success "$subject was linked successfully!"
    else
      log_failed "$subject:$err"
    fi

  done
}

#------------------------------------------------------------------------------
# Installing .config directories
#------------------------------------------------------------------------------

printf '%s\n' "> Installing .config directories..."

configs=(
  "alacritty"
  "codex"
  "lazygit"
  "nvim"
  "opencode"
  "tmux"
)
handle_links_list "$DOTFILES/config" "$HOME/.config" '%s config' configs

# -----------------------------------------------------------------------------
# Installing local and global scripts
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing local and global scripts..."

handle_links "$DOTFILES/bin/local" "$HOME/.local/bin" 'local script %s'

handle_links "$DOTFILES/bin/global" "/usr/local/bin" 'global script %s'

# -----------------------------------------------------------------------------
# Installing services
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing services..."

handle_links "$DOTFILES/service/local" "$HOME/.config/systemd/user" 'local service %s'

handle_links "$DOTFILES/service/global" "/etc/systemd/system" 'global service %s'

# -----------------------------------------------------------------------------
# Installing desktop files
# -----------------------------------------------------------------------------

printf '%s\n' "> Installing desktop files..."

handle_links "$DOTFILES/desktop/local" "$HOME/.local/share/applications" 'local desktop file %s'

handle_links "$DOTFILES/desktop/global" "/usr/share/applications" 'global desktop file %s'

handle_links "$DOTFILES/desktop/xfce4-helpers" "$HOME/.local/share/xfce4/helpers" 'xfce4 desktop helper file %s'

printf '%s\n' "> Finished!"
