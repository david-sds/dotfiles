#!/usr/bin/env bash

# Script session (exported: the binds read it at runtime)
export SELF_SESSION=$(tmux display -p -t "$TMUX_PANE" '#{session_id}')

# Row format
TARGET_FORMAT='#{session_name}:#{window_index}.#{pane_index}'
LIST_FORMAT="($TARGET_FORMAT) #{session_name}:#{window_name}.#{pane_title}"

# Reversed when the list label is set
IS_REVERSED='[ -n "$FZF_LIST_LABEL" ]'

# Pane list
LIST_PANES="tmux list-panes -a -f '#{!=:#{pane_id},$TMUX_PANE}' -F '$LIST_FORMAT' | if $IS_REVERSED; then tac; else cat; fi"

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
bind alt-r "transform-list-label($IS_REVERSED || echo ' reversed ')+reload-sync($LIST_PANES)" "M-r:reverse"
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

# Move pane (mark it, move the cursor, join the marked pane into the new row)
# Reversed list: swap before/after (-b)
BELOW_FLAG="\$($IS_REVERSED && echo -b)"
ABOVE_FLAG="\$($IS_REVERSED || echo -b)"
bind ctrl-alt-n "execute-silent(tmux select-pane -M; tmux select-pane -m -t {2})+down+execute-silent(tmux join-pane -d $BELOW_FLAG -t {2}; tmux select-pane -M)+reload-sync($LIST_PANES)" "C-M-n:move down"
bind ctrl-alt-p "execute-silent(tmux select-pane -M; tmux select-pane -m -t {2})+up+execute-silent(tmux join-pane -d $ABOVE_FLAG -t {2}; tmux select-pane -M)+reload-sync($LIST_PANES)" "C-M-p:move up"

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
FZF_ARGS+=(--bind "start:reload-sync($LIST_PANES)+$FOOTER" --bind "resize:$FOOTER")

# Selected pane
TARGET=$(fzf "${FZF_ARGS[@]}" | sed 's/).*//; s/(//')

[[ -n "$TARGET" ]] && tmux switch-client -t "$TARGET"
