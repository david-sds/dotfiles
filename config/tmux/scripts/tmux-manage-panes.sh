#!/usr/bin/env bash

# Live reload socket, one per open instance (tmux alert-bell hook calls --reload)
SOCK_PREFIX="${XDG_RUNTIME_DIR:-/tmp}/tmux-manage-panes-"
if [[ $1 == --reload ]]; then
  for s in "$SOCK_PREFIX"*.sock; do
    [ -S "$s" ] && curl -s -m 1 --unix-socket "$s" http -d 'reload-sync(eval "$LIST_PANES")' >/dev/null
  done
  exit 0
fi

# Script session (exported: the binds read it at runtime)
export SELF_SESSION=$(tmux display -p -t "$TMUX_PANE" '#{session_id}')

# Row format
TARGET_FORMAT='#{session_name}:#{window_index}.#{pane_index}'
# Line break marker (unit separator): tmux rows are one line, tr makes it \n
BREAK=$'\037'
# Rows start with a hidden id (pane/window id, field 1): fzf tracks it across reloads
# Two-line item: "title 🔔" / dim "window: ~/path command" (dim: --color nth)
LIST_FORMAT="#{pane_id}($TARGET_FORMAT) #{pane_title}#{?window_bell_flag, 🔔,}$BREAK#{window_name}: #{s|^$HOME|~|:pane_current_path} #{pane_current_command}"
# Collapsed item: one title line per pane (this pane left out)
# (sed pulls the first pane line up next to the target)
WINDOW_FORMAT="#{window_id}(#{session_name}:#{window_index})#{P:#{?#{==:#{pane_id},$TMUX_PANE},,$BREAK#{pane_title}}}#{?window_bell_flag, 🔔,}"

# Reversed when the list label is set, collapsed when the input label is set
IS_REVERSED='[ -n "$FZF_LIST_LABEL" ]'
IS_WINDOWS='[ -n "$FZF_INPUT_LABEL" ]'

# Pane list: all panes but this one, or windows (exported: --reload evals it inside fzf)
export LIST_PANES="if $IS_WINDOWS; then tmux list-windows -a -F '$WINDOW_FORMAT' | sed 's/^\([^(]*([^)]*)\)$BREAK/\1 /'; \
  else tmux list-panes -a -f '#{!=:#{pane_id},$TMUX_PANE}' -F '$LIST_FORMAT'; fi \
  | if $IS_REVERSED; then tac; else cat; fi \
  | tr '\n$BREAK' '\0\n'"

# Marked pane
MARKED='m=$(tmux list-panes -a -f "#{pane_marked}" -F "#{pane_id}"); [ -n "$m" ] || exit 0'

# Marked row highlight
SHOW_MARKED="m=\$(tmux list-panes -a -f '#{pane_marked}' -F '$TARGET_FORMAT'); i=\$($LIST_PANES | tr '\0' '\n' | grep '^[%@][0-9]*(' | grep -nF \"(\$m)\" | cut -d: -f1); echo clear-multi\${i:+\"+pos(\$i)+select+pos(\$(({n} + 1)))\"}"

# Target pane info
CWD='"$(tmux display -p -t {2} "#{pane_current_path}")"'
SESSION='$(tmux display -p -t {2} "#{session_name}")'

# Basic fzf args
FZF_ARGS=(
  --style full
  --layout reverse
  --delimiter '[()\n]'
  --nth ..3
  --color fg:dim,nth:regular
  --with-nth '({2}){3..}'
  --track
  --id-nth 1
  --multi
  --read0
  --marker-multi-line '┃┃┃'
  --listen "$SOCK_PREFIX${TMUX_PANE#%}.sock"
)

# Bind + hint
HINTS=()
bind() { FZF_ARGS+=(--bind "$1:$2"); HINTS+=("$3"); }

# Utils
bind enter "clear-multi+accept" "Enter:select"
bind ctrl-r "reload-sync($LIST_PANES)" "C-r:refresh"
bind alt-r "transform-list-label($IS_REVERSED || echo ' reversed ')+reload-sync($LIST_PANES)" "M-r:reverse"
bind alt-c "transform-input-label($IS_WINDOWS || echo ' windows ')+reload-sync($LIST_PANES)" "M-z:collapse"
bind ctrl-y "execute-silent(bash ~/.config/tmux/scripts/tmux-copy.sh 'tmux {2}')" "C-y:copy"
# Remove all panes except the last
bind ctrl-x "execute-silent(s=\$(tmux display -p -t {2} '#{session_id}'); n=\$(tmux list-panes -s -t \"\$s\" -F '#{pane_id}' | grep -vcxF \"$TMUX_PANE\"); if [ \"\$s\" != \"\$SELF_SESSION\" ] || [ \"\$n\" -gt 1 ]; then tmux kill-pane -t {2}; fi)+reload-sync($LIST_PANES)" "C-x:kill"

# Navigation
bind ctrl-f "first" "C-f:first"
bind ctrl-b "last" "C-b:last"

# Mark / Join(unite) / Swap(interchange)
bind "tab,ctrl-alt-m" "execute-silent(tmux select-pane -m -t {2})+reload-sync($LIST_PANES)" "C-M-m:mark"
bind ctrl-alt-j "execute-silent($MARKED; tmux join-pane -d -s \"\$m\" -t {2})+reload-sync($LIST_PANES)" "C-M-j:join"
bind ctrl-alt-s "execute-silent($MARKED; tmux swap-pane -d -s \"\$m\" -t {2})+reload-sync($LIST_PANES)" "C-M-s:swap"

# Move window: swap with the next/previous window (no window there = tmux errors, nothing happens),
# then show this pane's window again (tmux changes the active window on swap)
SWAP_WITH="tmux swap-window -d -s {2} -t \$(tmux display -p -t {2} '#{session_id}:#{e|%s:#{window_index},1}') \\; select-window -t \$TMUX_PANE"
bind ctrl-alt-n "execute-silent~$(printf "$SWAP_WITH" +)~+reload-sync($LIST_PANES)" "C-M-n:window down"
bind ctrl-alt-p "execute-silent~$(printf "$SWAP_WITH" -)~+reload-sync($LIST_PANES)" "C-M-p:window up"

# Create commands
bind alt-n "execute-silent(tmux split-window -d -t {2} -c $CWD)+reload-sync($LIST_PANES)" "M-n:new pane"
bind alt-w "execute-silent(tmux new-window -d -t $SESSION: -c $CWD)+reload-sync($LIST_PANES)" "M-w:new window"
bind alt-s "execute-silent(tmux new-session -d -c $CWD)+reload-sync($LIST_PANES)" "M-s:new session"

# Marked pane highlight
FZF_ARGS+=(--bind "load:transform:$SHOW_MARKED" --bind "btab:ignore")

# Footer
HINTS_NB=()
for h in "${HINTS[@]}"; do HINTS_NB+=("${h// /$'\001'}"); done
FOOTER="transform-footer(printf '%s   ' ${HINTS_NB[@]} | fold -s -w \$((FZF_COLUMNS - 6)) | tr '\001' ' ' | sed 's/^ *//; s/ *\$//')"
FZF_ARGS+=(--bind "start:reload-sync($LIST_PANES)+$FOOTER" --bind "resize:reload-sync($LIST_PANES)+$FOOTER")

# Selected pane
TARGET=$(fzf "${FZF_ARGS[@]}" | head -1 | sed 's/).*//; s/.*(//')

[[ -n "$TARGET" ]] && tmux switch-client -t "$TARGET"
