G = require("settings.globals")

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("walker"))
hl.bind("SUPER + Q", hl.dsp.window.kill())
hl.bind("SUPER + M", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + T", hl.dsp.layout("togglesplit"))

hl.bind("SUPER + CTRL + J", hl.dsp.layout("splitratio +0.1"))
hl.bind("SUPER + CTRL + K", hl.dsp.layout("splitratio -0.1"))

hl.bind("SUPER + G", hl.dsp.exec_cmd("~/.local/bin/toggle-gaps"))
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(G.terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(G.fileManager))
hl.bind("SUPER + B", hl.dsp.exec_cmd(G.browser))
hl.bind("SUPER + O", hl.dsp.exec_cmd(G.notes))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("~/.local/bin/open-floating-tui " .. G.bluetooth))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.local/bin/open-floating-tui " .. G.wifi))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("~/.local/bin/open-floating-tui " .. G.audio))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("~/.local/bin/open-floating-tui " .. G.system))

hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("~/.local/bin/walker-powermenu"))

hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region -z"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region -z --raw | satty --filename - --floating-hack"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SUPER + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window --raw | satty --filename - --floating-hack"))

hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1, follow = true }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2, follow = true }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3, follow = true }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4, follow = true }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5, follow = true }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6, follow = true }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7, follow = true }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8, follow = true }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9, follow = true }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true, locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("ALT + TAB", hl.dsp.window.cycle_next({ next = true }))
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }))
