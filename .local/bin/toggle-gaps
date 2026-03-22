#!/bin/bash

# Function to get variables from the variables file
get_variable() {
  grep "$1 =" ~/.config/hypr/settings/variables.conf | awk '{print $3}'
}

# 1. Get active workspace ID
id=$(hyprctl -j activeworkspace | jq ".id")

# 2. Defaults (Can be fetched via hyprctl as you noted)
GAPS_IN=$(get_variable "\$default_gaps_in")
GAPS_OUT=$(get_variable "\$default_gaps_in")
ROUNDING=$(get_variable "\$default_rounding")

# 3. Check if a rule already exists for this specific workspace
# We check if 'gapsIn: 0' is already set for this workspace ID
current_rule=$(hyprctl workspacerules -j | jq -r ".[] | select(.workspaceString == \"$id\") | .gapsIn[0]" | head -n1)

# 4. Toggle Logic
if [[ "$current_rule" == "0" ]]; then
  # RESTORE GAPS: Remove the specific workspace rule to fallback to general gaps
  # Or explicitly set them back
  hyprctl keyword workspace "$id, gapsin:$GAPS_IN, gapsout:$GAPS_OUT, rounding:$ROUNDING"
else
  # REMOVE GAPS: Set the rule for this workspace to 0
  # Note: We wrap the whole rule in quotes
  hyprctl keyword workspace "$id, gapsin:0, gapsout:0, rounding:0"
fi
