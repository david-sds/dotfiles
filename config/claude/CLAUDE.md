## tmux

When I mention a tmux target (`session:window.pane`, e.g. `0:1.2` or `backend:server.1`, copied with `prefix C-y`) or a window name (e.g. `server`, `tests`), read it with:

    tmux capture-pane -p -t <target> -S -200

After code changes, check the relevant pane for reload errors before saying it works. Never `send-keys` to my panes unless I ask.
