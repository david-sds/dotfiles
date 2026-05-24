hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = {
		class = "hyprland-run",
	},
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "floating-term-rule",
	match = {
		class = "floating_term",
	},
	float = true,
	center = true,
	size = { "(monitor_w*0.6)", "(monitor_h*0.7)" },
})

hl.window_rule({
	name = "gnome-calculator",
	match = {
		class = "org.gnome.(Calculator|Loupe)",
	},
	float = true,
})

hl.window_rule({
	name = "floating-gnome-apps",
	match = {
		class = "org.gnome.(Calculator|Loupe)",
	},
	float = true,
})

hl.window_rule({
	name = "floating-alt-steam",
	match = {
		class = "steam",
		title = "negative:.*Steam$",
	},
	float = true,
})

hl.window_rule({
	name = "floating-color-picker",
	match = {
		title = "Oklch Color Picker",
	},
	float = true,
})

hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })

hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })
