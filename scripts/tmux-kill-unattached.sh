#!/usr/bin/env bash

tmux list-sessions -F "#{session_name} #{session_attached}" |
  while read s a; do
    [ "$a" = "0" ] && tmux kill-session -t "$s"
  done

tmux display-message " Tmux sessions cleared!"
