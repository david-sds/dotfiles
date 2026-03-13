#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/alacritty.toml"

fonts=(
  "ProggyClean Nerd Font Mono"
  "ProggyClean CE Nerd Font Mono"
  "ProggyCleanSZ Nerd Font Mono"
  "Terminess Nerd Font Mono"
  "DepartureMono Nerd Font Mono"
)

show_list() {
  local i
  for i in "${!fonts[@]}"; do
    printf '%d. %s\n' "$((i + 1))" "${fonts[i]}"
  done
}

set_font() {
  local family="$1"
  perl -0pi -e 's/normal = \{ family = ".*?", style = "Regular" \}/normal = { family = "'"$family"'", style = "Regular" }/' "$CONFIG_FILE"
  printf 'Set Alacritty font to: %s\n' "$family"
}

case "${1:-}" in
"")
  show_list
  ;;
next)
  current="$(sed -n 's/^normal = { family = "\(.*\)", style = "Regular" }$/\1/p' "$CONFIG_FILE")"
  next_index=0
  for i in "${!fonts[@]}"; do
    if [[ "${fonts[i]}" == "$current" ]]; then
      next_index=$(((i + 1) % ${#fonts[@]}))
      break
    fi
  done
  set_font "${fonts[next_index]}"
  ;;
[1-9]*)
  index=$((10#$1))
  if ((index < 1 || index > ${#fonts[@]})); then
    printf 'Index out of range. Use 1-%d.\n' "${#fonts[@]}" >&2
    exit 1
  fi
  set_font "${fonts[index - 1]}"
  ;;
*)
  set_font "$*"
  ;;
esac
