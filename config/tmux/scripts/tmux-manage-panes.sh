#!/usr/bin/env bash

# Script session (exported: the binds read it at runtime)
export SELF_SESSION=$(tmux display -p -t "$TMUX_PANE" '#{session_id}')

# Row format
TARGET_FORMAT='#{session_name}:#{window_index}.#{pane_index}'
LIST_FORMAT="($TARGET_FORMAT) #{session_name}:#{window_name}.#{pane_title}"

# Pane list
LIST_PANES="tmux list-panes -a -f '#{!=:#{pane_id},$TMUX_PANE}' -F '$LIST_FORMAT'"

# Marked pane
MARKED='m=$(tmux list-panes -a -f "#{pane_marked}" -F "#{pane_id}"); [ -n "$m" ] || exit 0'

# Marked row highlight
SHOW_MARKED="m=\$(tmux list-panes -a -f '#{pane_marked}' -F '$TARGET_FORMAT'); i=\$($LIST_PANES | grep -nF \"(\$m)\" | cut -d: -f1); echo clear-multi\${i:+\"+pos(\$i)+select+pos(\$(({n} + 1)))\"}"

# Target pane info
CWD='"$(tmux display -p -t {2} "#{pane_current_path}")"'
SESSION='$(tmux display -p -t {2} "#{session_name}")'

# Basic fzf args
FZF_ARGS=(
  --style full
  --layout reverse
  --delimiter '[()]'
  --multi
)

# Bind + hint
HINTS=()
bind() { FZF_ARGS+=(--bind "$1:$2"); HINTS+=("$3"); }

# Utils
bind enter "clear-multi+accept" "Enter:select"
bind ctrl-r "reload-sync($LIST_PANES)" "C-r:refresh"
bind ctrl-x "execute-silent(s=\$(tmux display -p -t {2} '#{session_id}'); n=\$(tmux list-panes -s -t \"\$s\" -F '#{pane_id}' | grep -vcxF \"$TMUX_PANE\"); if [ \"\$s\" != \"\$SELF_SESSION\" ] || [ \"\$n\" -gt 1 ]; then tmux kill-pane -t {2}; fi)+reload-sync($LIST_PANES)" "C-x:kill"
bind ctrl-y "execute-silent(bash ~/.config/tmux/scripts/tmux-copy.sh 'tmux {2}')" "C-y:copy"

# Mark / Join / Swap
bind "tab,ctrl-alt-m" "execute-silent(tmux select-pane -m -t {2})+reload-sync($LIST_PANES)" "C-M-m:mark"
bind ctrl-alt-u "execute-silent($MARKED; tmux join-pane -d -s \"\$m\" -t {2} && tmux select-pane -m -t \"\$m\")+reload-sync($LIST_PANES)" "C-M-u:join"
bind ctrl-alt-i "execute-silent($MARKED; tmux swap-pane -d -s \"\$m\" -t {2} && tmux select-pane -m -t \"\$m\")+reload-sync($LIST_PANES)" "C-M-i:swap"

# Move pane
bind ctrl-alt-j,ctrl-alt-n "execute-silent(tmux swap-pane -d -D -t {2})+reload-sync($LIST_PANES)+down" "C-M-j/n:move down"
bind ctrl-alt-k,ctrl-alt-p "execute-silent(tmux swap-pane -d -U -t {2})+reload-sync($LIST_PANES)+up" "C-M-k/p:move up"

# Create commands
bind alt-n "execute-silent(tmux split-window -d -t {2} -c $CWD)+reload-sync($LIST_PANES)" "M-n:pane"
bind alt-w "execute-silent(tmux new-window -d -t $SESSION -c $CWD)+reload-sync($LIST_PANES)" "M-w:window"
bind alt-s "execute-silent(tmux new-session -d -c $CWD)+reload-sync($LIST_PANES)" "M-s:session"

# Marked pane highlight
FZF_ARGS+=(--bind "load:transform:$SHOW_MARKED" --bind "btab:ignore")

# Footer
HINTS_NB=()
for h in "${HINTS[@]}"; do HINTS_NB+=("${h// /$'\001'}"); done
FOOTER="transform-footer(printf '%s   ' ${HINTS_NB[@]} | fold -s -w \$((FZF_COLUMNS - 6)) | tr '\001' ' ' | sed 's/^ *//; s/ *\$//')"
FZF_ARGS+=(--bind "start:reload-sync($LIST_PANES)+$FOOTER" --bind "resize:$FOOTER")

# Selected pane
TARGET=$(fzf "${FZF_ARGS[@]}" | sed 's/).*//; s/(//')

[[ -n "$TARGET" ]] && tmux switch-client -t "$TARGET"
