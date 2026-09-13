#!/usr/bin/env bash

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/.."

pacman -Qen >"$DOTFILES/log/pkglist-native.txt"
pacman -Qem >"$DOTFILES/log/pkglist-aur.txt"
