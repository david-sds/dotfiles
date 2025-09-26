export HISTTIMEFORMAT="%d/%m/%y %T "

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[ -f /home/david/.dart-cli-completion/bash-config.bash ] && . /home/david/.dart-cli-completion/bash-config.bash || true
## [/Completion]

