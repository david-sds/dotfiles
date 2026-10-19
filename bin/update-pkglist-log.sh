#!/usr/bin/env bash

# Restore on a fresh Fedora install, in order:
#
#   1. RPM Fusion (nvidia, cuda and other nonfree packages come from it):
#        sudo dnf install \
#          https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#          https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#
#   2. COPR repos from log/pkglist-copr.txt (copr.fedorainfracloud.org/<owner>/<project>):
#        sudo dnf copr enable dejan/lazygit
#
#   3. Packages:
#        sudo dnf install --skip-unavailable $(cat log/pkglist-dnf.txt)
#      kernel-modules is required for the MT7921 wifi driver (mt7921e); without it
#      wifi breaks. dbeaver-ce came from a downloaded rpm: grab it from dbeaver.io.
#
#   4. Flatpaks:
#        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#        xargs -a log/pkglist-flatpak.txt -L1 flatpak install -y
#
#   5. Nvidia with Secure Boot on: the akmods signing key must be enrolled (MOK)
#      or the nvidia module won't load. The nouveau blacklist kernel args are added
#      by akmod-nvidia itself.
#        sudo akmods --force
#        sudo mokutil --import /etc/pki/akmods/certs/public_key.der  # set a one-time password
#        reboot  # blue MOK screen -> Enroll MOK -> enter that password
#      To reuse the old key instead, restore a backup of /etc/pki/akmods (private key,
#      never commit it) before running akmods.

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/.."

if command -v pacman >/dev/null; then
	pacman -Qen >"$DOTFILES/log/pkglist-native.txt"
	pacman -Qem >"$DOTFILES/log/pkglist-aur.txt"
fi

if command -v dnf >/dev/null; then
	# kmod-* are built per kernel by akmod-nvidia, so they're not reinstallable by name
	dnf repoquery --userinstalled --qf '%{name}\n' | grep -v '^kmod-' | sort -u >"$DOTFILES/log/pkglist-dnf.txt"
	dnf copr list | grep -v '(disabled)' >"$DOTFILES/log/pkglist-copr.txt"
fi

if command -v flatpak >/dev/null; then
	flatpak list --app --columns=origin,application >"$DOTFILES/log/pkglist-flatpak.txt"
fi
