hl.config({
	input = {
		kb_layout = "br,br,us,us",
		kb_variant = "nodeadkeys,,,intl",
		kb_options = "compose:caps,grp:shifts_toggle",
		kb_model = "",
		kb_rules = "",
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "pinch",
	action = "cursorZoom",
	zoom_level = 1,
	mode = "live",
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})
