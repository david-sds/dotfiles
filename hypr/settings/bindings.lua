-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- META+J/K/L moved to SHIFT variants (originals unbound)

hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

hl.unbind("SUPER + J")
o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))

hl.unbind("SUPER + K")
o.bind("SUPER + CTRL + K", "Keybindings", "omarchy-menu-keybindings")

hl.unbind("SUPER + L")
hl.unbind("SUPER + CTRL + L")
o.bind("SUPER + CTRL + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

o.bind("SUPER + H", "Select left window", hl.dsp.focus({ direction = "left" }))
o.bind("SUPER + L", "Select right window", hl.dsp.focus({ direction = "right" }))
o.bind("SUPER + K", "Select upper window", hl.dsp.focus({ direction = "up" }))
o.bind("SUPER + J", "Select bottom window", hl.dsp.focus({ direction = "down" }))

o.bind("SUPER + SHIFT + H", "Move window left", hl.dsp.window.move({ direction = "left" }))
o.bind("SUPER + SHIFT + L", "Move right window", hl.dsp.window.move({ direction = "right" }))
o.bind("SUPER + SHIFT + K", "Move upper window", hl.dsp.window.move({ direction = "up" }))
o.bind("SUPER + SHIFT + J", "Move bottom window", hl.dsp.window.move({ direction = "down" }))

hl.unbind("SUPER + N")
hl.unbind("SUPER + P")
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + SHIFT + P")

-- Utils
U = require("hypr.utils")

U.multibind({
	"SUPER + mouse_up",
	"SUPER + KP_Subtract",
}, U.change_zoom(-0.5))
U.multibind({
	"SUPER + mouse_down",
	"SUPER + KP_Add",
}, U.change_zoom(0.5))

o.bind("SUPER + N", "Go to next workspace", function()
	hl.dispatch(hl.dsp.focus({
		workspace = U.get_relative_workspace_id(1),
	}))
end)
o.bind("SUPER + P", "Go to previous workspace", function()
	hl.dispatch(hl.dsp.focus({
		workspace = U.get_relative_workspace_id(-1),
	}))
end)
o.bind("SUPER + SHIFT + N", "Move window to next workspace", function()
	hl.dispatch(hl.dsp.window.move({
		workspace = U.get_relative_workspace_id(1),
		follow = true,
	}))
end)
o.bind("SUPER + SHIFT + P", "Move window to previous workspace", function()
	hl.dispatch(hl.dsp.window.move({
		workspace = U.get_relative_workspace_id(-1),
		follow = true,
	}))
end)
