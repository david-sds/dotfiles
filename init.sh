#!/usr/bin/env bash

# Variables
SESSION="educria"

# Create session and first window
tmux new-session -d -s "$SESSION" -n proj

# Create other windows
tmux new-window -t "$SESSION":2 -n exec
tmux new-window -t "$SESSION":3 -n conf

# Split windows in panes and resize them
tmux select-window -t "$SESSION":1
tmux split-window -v -t "$SESSION":1
tmux resize-pane -t "$SESSION":1 -D 25
tmux select-window -t "$SESSION":2
tmux split-window -v -t "$SESSION":2

# Run commands in panes
tmux send-keys -t "$SESSION":1.1 'cd ~/workspace/educria/' Enter
tmux send-keys -t "$SESSION":1.2 'cd ~/workspace/educria/espaco_maker_app/ && flutter run -d chrome --dart-define env=-local' Enter
tmux send-keys -t "$SESSION":2.1 'cd ~/workspace/educria/espaco_maker_app/ && dart run build_runner watch -d' Enter
tmux send-keys -t "$SESSION":2.2 "cd ~/workspace/educria/espaco_maker_back/ && nvm use $(cat .nvmrc) && npm run start:local" Enter
tmux send-keys -t "$SESSION":3 'cd ~/.config/' Enter

# Attach to session
tmux select-window -t "$SESSION":1
tmux select-pane -t "$SESSION":1.1
tmux attach -t "$SESSION"
