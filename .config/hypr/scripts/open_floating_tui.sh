#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "Usage: ./open_floating.sh <command>"
  exit 1
fi

# Launch the terminal with our special class, executing the command
# Change 'kitty' to 'alacritty' or your preferred terminal if needed
alacritty --class floating_term -e "$1"
