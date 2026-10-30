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

# Footer hints
HINTS='Enter:select  C-x:kill  C-y:copy  M-n:pane  M-w:window  M-s:session  C-M-m:mark  C-M-u:join  C-M-i:swap'
FOOTER="transform-footer(echo '$HINTS' | fold -s -w \$((FZF_COLUMNS - 6)))"

# fzf args
FZF_ARGS=(
  # Basic
  --style full
  --layout reverse
  --delimiter '[()]'
  --multi
  --bind "ctrl-alt-n:down"
  --bind "ctrl-alt-p:up"

  # Utils
  --bind "ctrl-x:execute-silent(s=\$(tmux display -p -t {2} '#{session_id}'); n=\$(tmux list-panes -s -t \"\$s\" -F '#{pane_id}' | grep -vcxF \"$TMUX_PANE\"); if [ \"\$s\" != \"\$SELF_SESSION\" ] || [ \"\$n\" -gt 1 ]; then tmux kill-pane -t {2}; fi)+reload-sync($LIST_PANES)"
  --bind "ctrl-y:execute-silent(bash ~/.config/tmux/scripts/tmux-copy.sh 'tmux {2}')"

  # Footer
  --bind "start:reload-sync($LIST_PANES)+$FOOTER"
  --bind "resize:$FOOTER"

  # Use fzf selection for marked panes
  --bind "load:transform:$SHOW_MARKED"
  --bind "btab:ignore"
  --bind "enter:clear-multi+accept"

  # Mark / Join / Swap
  --bind "tab,ctrl-alt-m:execute-silent(tmux select-pane -m -t {2})+reload-sync($LIST_PANES)"
  --bind "ctrl-alt-u:execute-silent($MARKED; tmux join-pane -d -s \"\$m\" -t {2} && tmux select-pane -m -t \"\$m\")+reload-sync($LIST_PANES)"
  --bind "ctrl-alt-i:execute-silent($MARKED; tmux swap-pane -d -s \"\$m\" -t {2} && tmux select-pane -m -t \"\$m\")+reload-sync($LIST_PANES)"

  # Create commands
  --bind "alt-n:execute-silent(tmux split-window -d -t {2} -c $CWD)+reload-sync($LIST_PANES)"
  --bind "alt-w:execute-silent(tmux new-window -d -t $SESSION -c $CWD)+reload-sync($LIST_PANES)"
  --bind "alt-s:execute-silent(tmux new-session -d -c $CWD)+reload-sync($LIST_PANES)"
)

# Selected pane
TARGET=$(fzf "${FZF_ARGS[@]}" | sed 's/).*//; s/(//')

[[ -n "$TARGET" ]] && tmux switch-client -t "$TARGET"
