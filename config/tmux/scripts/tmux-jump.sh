#!/usr/bin/env bash
set -euo pipefail

action=$1
argument=${2:-}

read -r socket server_pid < <(tmux display-message -p '#{b:socket_path} #{pid}')

state="${XDG_STATE_HOME:-$HOME/.local/state}/tmux/jumplist/$socket"
visited="$state/visited"
undone="$state/undone"

wait_for_my_turn() {
  mkdir -p "$state"
  exec {lock}>"$state/lock"
  flock "$lock"
}

start_fresh_if_server_restarted() {
  [[ $(cat "$state/server_pid" 2>/dev/null) == "$server_pid" ]] && return
  echo "$server_pid" >"$state/server_pid"
  : >"$visited"
  : >"$undone"
}

forget_closed_panes() {
  local open_panes list
  open_panes=$(tmux list-panes -a -F '#{pane_id}')
  for list in "$visited" "$undone"; do
    { grep -Fx "$open_panes" "$list" || true; } | uniq >"$list.tmp"
    mv "$list.tmp" "$list"
  done
}

last() {
  tail -n 1 "$1"
}

move_last() {
  last "$1" >>"$2"
  sed -i '$d' "$1"
}

on_screen() {
  tmux list-clients -F '#{pane_id}' | grep -qx "$1"
}

window_of() {
  tmux display-message -p -t "$1" '#{window_id}' 2>/dev/null || true
}

record() {
  local pane=$1 win i list
  on_screen "$pane" || return 0
  [[ $pane == "$(last "$visited")" ]] && return
  # Like nvim's jumplist: a new move after going back keeps the panes ahead
  # (put them back in order, then the pane we're leaving) instead of dropping them.
  if [[ -s $undone ]]; then
    local from
    from=$(last "$visited")
    tac "$undone" >>"$visited"
    echo "$from" >>"$visited"
    : >"$undone"
  fi
  # Walk the top entries that share this pane's window; if the pane is
  # already among them, drop that old entry (no A B A B ... from C-h spam).
  win=$(window_of "$pane")
  mapfile -t list <"$visited"
  for ((i = ${#list[@]} - 1; i >= 0; i--)); do
    [[ $(window_of "${list[i]}") == "$win" ]] || break
    if [[ ${list[i]} == "$pane" ]]; then
      sed -i "$((i + 1))d" "$visited"
      break
    fi
  done
  echo "$pane" >>"$visited"
  : >"$undone"
}

back() {
  local client=$1
  [[ $(wc -l <"$visited") -gt 1 ]] || return 0
  move_last "$visited" "$undone"
  tmux switch-client -c "$client" -t "$(last "$visited")"
}

forward() {
  local client=$1
  [[ -s $undone ]] || return 0
  move_last "$undone" "$visited"
  tmux switch-client -c "$client" -t "$(last "$visited")"
}

wait_for_my_turn
start_fresh_if_server_restarted

case $action in
record) record "$argument" ;;
back) forget_closed_panes && back "$argument" ;;
forward) forget_closed_panes && forward "$argument" ;;
esac
