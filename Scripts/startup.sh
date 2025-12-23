#!/bin/bash

xbindkeys
xfconf-query -c xfwm4 -p /general/workspace_count -s 4
paplay /home/david/.local/share/sounds/Smooth/stereo/winxp_startup.mp3
