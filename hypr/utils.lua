local G = require("settings.globals")

local M = {}

local gaps_disabled = {}
M.toggle_gaps = function()
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end

	if gaps_disabled[ws.id] then
		hl.workspace_rule({
			workspace = tostring(ws.id),
			gaps_in = G.default_general_gaps_in,
			gaps_out = G.default_general_gaps_out,
			decorate = true,
		})
		hl.window_rule({
			match = { workspace = tostring(ws.id) },
			rounding = G.default_decoration_rounding,
			border_size = G.default_general_border_size,
		})
		gaps_disabled[ws.id] = false
	else
		hl.workspace_rule({
			workspace = tostring(ws.id),
			gaps_in = 0,
			gaps_out = 0,
			decorate = false,
		})
		hl.window_rule({
			match = { workspace = tostring(ws.id) },
			rounding = 0,
			border_size = 0,
		})
		gaps_disabled[ws.id] = true
	end
end

local transparency_disabled = {}
M.toggle_opacity = function()
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end

	if transparency_disabled[ws.id] then
		hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity_override", value = G.default_decoration_opacity }))
		hl.dispatch(
			hl.dsp.window.set_prop({ prop = "opacity_inactive_override", value = G.default_decoration_inactive_opacity })
		)
		hl.dispatch(
			hl.dsp.window.set_prop({ prop = "active_border_color", value = G.default_general_col_active_border })
		)
		hl.dispatch(
			hl.dsp.window.set_prop({ prop = "inactive_border_color", value = G.default_general_col_inactive_border })
		)
		transparency_disabled[ws.id] = false
	else
		hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity_override", value = 1 }))
		hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity_inactive_override", value = 1 }))
		hl.dispatch(
			hl.dsp.window.set_prop({ prop = "active_border_color", value = G.custom_general_col_active_border })
		)
		hl.dispatch(
			hl.dsp.window.set_prop({ prop = "inactive_border_color", value = G.custom_general_col_inactive_border })
		)
		transparency_disabled[ws.id] = true
	end
end

local zoom = 1.0
M.change_zoom = function(delta)
	return function()
		zoom = math.max(1.0, math.min(4.0, zoom + delta))

		hl.config({
			cursor = {
				zoom_factor = zoom,
				zoom_disable_aa = true,
			},
			binds = {
				pass_mouse_when_bound = false,
				scroll_event_delay = 0,
			},
		})
	end
end

return M
