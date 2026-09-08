-- Applications
o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + ALT + L", "Lock system", "omarchy-system-lock")

-- Tiling
o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + X", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")
o.bind("SUPER + CTRL + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + CTRL + K", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + CTRL + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + CTRL + P", "Pseudo window", hl.dsp.window.pseudo())

o.bind("SUPER + H", "Select left window", hl.dsp.focus({ direction = "left" }))
o.bind("SUPER + L", "Select right window", hl.dsp.focus({ direction = "right" }))
o.bind("SUPER + K", "Select upper window", hl.dsp.focus({ direction = "up" }))
o.bind("SUPER + J", "Select bottom window", hl.dsp.focus({ direction = "down" }))

o.bind("SUPER + SHIFT + H", "Move window left", hl.dsp.window.move({ direction = "left" }))
o.bind("SUPER + SHIFT + L", "Move right window", hl.dsp.window.move({ direction = "right" }))
o.bind("SUPER + SHIFT + K", "Move upper window", hl.dsp.window.move({ direction = "up" }))
o.bind("SUPER + SHIFT + J", "Move bottom window", hl.dsp.window.move({ direction = "down" }))

for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
	o.bind(
		"SUPER + SHIFT + " .. key,
		"Move window to workspace " .. workspace,
		hl.dsp.window.move({ workspace = tostring(workspace) })
	)
end

o.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind(
	"SUPER + SHIFT + S",
	"Move window to scratchpad",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })
)

o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
o.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
o.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())

o.bind(
	"SUPER + LEFT",
	"Expand window left",
	hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + RIGHT",
	"Shrink window left",
	hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + UP",
	"Shrink window up",
	hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
	{ repeating = true }
)
o.bind(
	"SUPER + DOWN",
	"Expand window down",
	hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
	{ repeating = true }
)

if o.cmd_present("voxtype") then
	o.bind("SUPER + CTRL + X", "Toggle dictation", "voxtype record toggle")
	o.bind("F9", "Start dictation (push-to-talk)", "voxtype record start")
	o.bind("F9", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })
end

o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle")
o.bind("SUPER + ALT + SPACE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + CTRL + E", "Emojis", "omarchy-shell shell toggle omarchy.emojis")
o.bind("SUPER + CTRL + C", "Capture menu", "omarchy-menu toggle capture")
o.bind("SUPER + CTRL + O", "Toggle menu", "omarchy-menu toggle toggle")
o.bind("SUPER + CTRL + H", "Hardware menu", "omarchy-menu toggle hardware")
o.bind("SUPER + ESCAPE", "System menu", "omarchy-menu toggle system")
o.bind("XF86PowerOff", "Power menu", "omarchy-menu toggle system", { locked = true })
o.bind("SUPER + CTRL + Q", "Calculator", "omacalc")
o.bind("XF86Calculator", "Calculator", "omacalc")

o.bind_toggle("SUPER + SHIFT + SPACE", "Toggle top bar", "bar")
o.bind("SUPER + CTRL + SPACE", "Background switcher", "omarchy-menu toggle background")
o.bind("SUPER + SHIFT + CTRL + SPACE", "Theme menu", "omarchy-menu toggle theme")
o.bind("SUPER + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")
o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", "omarchy-hyprland-window-gaps-toggle")
o.bind(
	"SUPER + CTRL + BACKSPACE",
	"Toggle single-window square aspect",
	"omarchy-hyprland-window-single-square-aspect-toggle"
)

o.bind("PRINT", "Screenshot", hl.dsp.exec_cmd("hyprshot -m region -z"))
o.bind(
	"SHIFT + PRINT",
	"Screenshot and Edit",
	hl.dsp.exec_cmd("hyprshot -m region -z --raw | satty --filename - --floating-hack")
)
o.bind("SUPER + PRINT", "Screenshot window", hl.dsp.exec_cmd("hyprshot -m window"))
o.bind(
	"SUPER + SHIFT + PRINT",
	"Screenshot window and edit",
	hl.dsp.exec_cmd("hyprshot -m window --raw | satty --filename - --floating-hack")
)

o.bind("SUPER + C", "Color picker", "pkill hyprpicker || hyprpicker -a")

o.bind(
	"ALT + PRINT",
	"Screenrecording",
	"omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord"
)
o.bind("SUPER + ALT + code:34", "Make webcam overlay smaller", "omarchy-capture-webcam-resize smaller")
o.bind("SUPER + ALT + code:35", "Make webcam overlay larger", "omarchy-capture-webcam-resize larger")
o.bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "omarchy-capture-text")
o.bind(
	"ALT + PRINT",
	"Screenrecording",
	"omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord"
)

o.bind("SUPER + CTRL + ALT + T", "Show time", "omarchy-notification-time")
o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", "omarchy-notification-battery")
o.bind("SUPER + CTRL + ALT + W", "Toggle weather", "omarchy-notification-weather")

for panel = 1, 9 do
	o.bind(
		"SUPER + CTRL + code:" .. tostring(panel + 9),
		"Bar panel " .. panel,
		"omarchy-shell -q shell togglePanelAt right " .. panel
	)
end

-- Utils
U = require("hypr.utils")

-- ZOOM
o.bind("SUPER + code:21", "Increase zoom", U.change_zoom(-0.5), { repeating = true })
o.bind("SUPER + code:20", "Reduce zoom", U.change_zoom(0.5), { repeating = true })
o.bind("SUPER + mouse_up", "Increase zoom", U.change_zoom(0.5))
o.bind("SUPER + mouse_down", "Reduce zoom", U.change_zoom(-0.5))

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

-- Media
o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
o.bind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })
o.bind("XF86AudioMute", "Mute", "omarchy-audio-output-volume mute-toggle", { locked = true })
o.bind("XF86AudioMicMute", "Mute microphone", "omarchy-audio-input-mute", { locked = true })
o.bind("XF86MonBrightnessUp", "Brightness up", "omarchy-brightness-display +5%", { locked = true, repeating = true })
o.bind(
	"XF86MonBrightnessDown",
	"Brightness down",
	"omarchy-brightness-display 5%-",
	{ locked = true, repeating = true }
)
o.bind(
	"SHIFT + XF86MonBrightnessUp",
	"Brightness maximum",
	"omarchy-brightness-display 100%",
	{ locked = true, repeating = true }
)
o.bind(
	"SHIFT + XF86MonBrightnessDown",
	"Brightness minimum",
	"omarchy-brightness-display 1%",
	{ locked = true, repeating = true }
)
o.bind(
	"XF86KbdBrightnessUp",
	"Keyboard brightness up",
	"omarchy-brightness-keyboard up",
	{ locked = true, repeating = true }
)
o.bind(
	"XF86KbdBrightnessDown",
	"Keyboard brightness down",
	"omarchy-brightness-keyboard down",
	{ locked = true, repeating = true }
)
o.bind("XF86KbdLightOnOff", "Keyboard backlight cycle", "omarchy-brightness-keyboard cycle", { locked = true })
o.bind_toggle("XF86TouchpadToggle", "Toggle touchpad", "touchpad", { locked = true })
o.bind("XF86TouchpadOn", "Enable touchpad", "omarchy-toggle-touchpad on", { locked = true })
o.bind("XF86TouchpadOff", "Disable touchpad", "omarchy-toggle-touchpad off", { locked = true })

-- Precise volume and brightness controls.
o.bind(
	"ALT + XF86AudioRaiseVolume",
	"Volume up precise",
	"omarchy-audio-output-volume +1",
	{ locked = true, repeating = true }
)
o.bind(
	"ALT + XF86AudioLowerVolume",
	"Volume down precise",
	"omarchy-audio-output-volume -1",
	{ locked = true, repeating = true }
)
o.bind(
	"ALT + XF86MonBrightnessUp",
	"Brightness up precise",
	"omarchy-brightness-display +1%",
	{ locked = true, repeating = true }
)
o.bind(
	"ALT + XF86MonBrightnessDown",
	"Brightness down precise",
	"omarchy-brightness-display 1%-",
	{ locked = true, repeating = true }
)

-- Media controls.
o.bind("XF86AudioNext", "Next track", "omarchy-shell media next", { locked = true })
o.bind("ALT + XF86AudioPlay", "Next track", "omarchy-shell media next", { locked = true })
o.bind("XF86AudioPause", "Pause", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPlay", "Play", "omarchy-shell media playPause", { locked = true })
o.bind("XF86AudioPrev", "Previous track", "omarchy-shell media previous", { locked = true })
o.bind("ALT + SHIFT + XF86AudioPlay", "Previous track", "omarchy-shell media previous", { locked = true })
o.bind("XF86Eject", "Eject media", "eject", { locked = true })

o.bind("SHIFT + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
o.bind("SHIFT + XF86AudioPause", "Switch media source", "omarchy-audio-source-switch", { locked = true })
o.bind("SHIFT + XF86AudioPlay", "Switch media source", "omarchy-audio-source-switch", { locked = true })
