#!/usr/bin/env bash

# Single Ctrl+C aborts the whole script
trap 'echo "Aborted."; return 1 2>/dev/null || exit 1' INT

install_walker() {
  local repo=/opt/walker
  local binary="$repo"/target/release/walker

  local deps=(gtk4-layer-shell poppler-glib protobuf)
  if ! pacman -Q "${deps[@]}" &>/dev/null; then
    sudo pacman -S --needed "${deps[@]}"
  fi

  if [ ! -x "$binary" ]; then
    if [ -d "$repo" ]; then
      sudo git -C "$repo" pull
    else
      sudo git clone https://github.com/abenz1267/walker.git "$repo"
    fi
    sudo bash -c "cd '$repo' && cargo build --release"
  fi

  sudo ln -sf "$binary" /usr/local/bin/walker
}

install_elephant() {
  local repo=/opt/elephant
  local providers_dir=$HOME/.config/elephant/providers
  local binary=/opt/elephant/bin/elephant

  local deps=(libqalculate imagemagick fd)
  if ! pacman -Q "${deps[@]}" &>/dev/null; then
    sudo pacman -S --needed "${deps[@]}"
  fi

  if [ ! -x "$binary" ]; then
    if [ -d "$repo" ]; then
      sudo git -C "$repo" pull
    else
      sudo git clone https://github.com/abenz1267/elephant "$repo"
    fi
    sudo bash -c "cd '/opt/elephant/cmd/elephant' && go build -o '$binary' elephant.go"
  fi

  sudo ln -sf "$binary" /usr/local/bin/elephant

  mkdir -p "$providers_dir"

  # Install plugins listed
  local plugin
  for plugin in "${ELEPHANT_PLUGINS[@]}"; do
    add_elephant_plugin "$repo" "$providers_dir" "$plugin"
  done

  # Uninstall plugins not listed
  local so installed
  for so in "$providers_dir"/*.so; do
    [ -e "$so" ] || continue
    installed=$(basename "$so" .so)
    if ! printf '%s\n' "${ELEPHANT_PLUGINS[@]}" | grep -qx "$installed"; then
      remove_elephant_plugin "$installed"
    fi
  done
}

add_elephant_plugin() {
  local repo=$1 providers_dir=$2 name=$3
  local src="$repo/internal/providers/$name"

  if [ ! -d "$src" ]; then
    echo "No such provider: $name" >&2
    return 1
  fi

  sudo bash -c "cd '$src' && go build -buildmode=plugin -o '$name.so'" &&
    sudo cp "$src/$name.so" "$providers_dir/" &&
    echo "Installed plugin: $name" ||
    echo "Failed to build plugin: $name" >&2
}

remove_elephant_plugin() {
  local providers_dir=$HOME/.config/elephant/providers
  local so="$providers_dir/$1.so"

  if [ -f "$so" ]; then
    rm "$so"
    echo "Removed plugin: $1"
  else
    echo "Not installed: $1"
  fi
}

ELEPHANT_PLUGINS=(
  desktopapplications
  calc
  files
  clipboard
  symbols
  websearch
)

install_walker
install_elephant
