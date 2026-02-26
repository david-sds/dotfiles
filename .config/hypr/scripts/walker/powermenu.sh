#!/bin/bash

options="  Shutdown
  Reboot
󰤄  Suspend
  Lock
󰍃  Log Out"

selected=$(echo -e "$options" | walker --dmenu -H)

case "$selected" in
*"Shutdown"*) systemctl poweroff ;;
*"Reboot"*) systemctl reboot ;;
*"Suspend"*) systemctl suspend ;;
*"Lock"*) hyprlock ;;
*"Log Out"*) hyprctl dispatch exit ;;
esac
