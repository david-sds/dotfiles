local G = require("core.globals")

local M = {}

local function _shellesc(s)
	return (s:gsub("'", "'\\''"))
end
---@enum Urgency
local Urgency = {
	INFO = "low",
	WARNING = "normal",
	ERROR = "critical",
}
---@param title string The notification title
---@param body string? The notification body
---@param urgency Urgency Urgency level INFO/WARNING/ERROR
---@return boolean success True if notify-send ran without error
M.notify = function(title, body, urgency)
	local command
	if body == nil then
		command = string.format("notify-send -u '%s' '%s'", _shellesc(urgency), _shellesc(title))
	else
		command = string.format(
			"notify-send -u '%s' '%s' '%s'",
			_shellesc(urgency),
			_shellesc(title),
			_shellesc(body)
		)
	end
	local ok = os.execute(command)
	return ok == true
end

M.toggle_layout = function()
	local config = hl.get_config("general.layout")
	local layouts = { "dwindle", "scrolling" }

	for i, layout in ipairs(layouts) do
		if config == layout then
			local next_index = (i % #layouts) + 1
			local next_layout = layouts[next_index]

			hl.config({ general = { layout = next_layout } })

			M.notify(
				"Layout changed!",
				layout:upper() .. " > " .. next_layout:upper(),
				Urgency.INFO
			)
			break
		end
	end
end

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
		M.notify("Gaps enabled on this workspace!", nil, Urgency.INFO)
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
		M.notify("Gaps disabled on this workspace!", nil, Urgency.INFO)
	end
end

local transparency_disabled = {}
M.toggle_opacity = function()
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end

	if transparency_disabled[ws.id] then
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "opacity_override",
			value = G.default_decoration_opacity,
		}))
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "opacity_inactive_override",
			value = G.default_decoration_inactive_opacity,
		}))
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "active_border_color",
			value = G.default_general_col_active_border,
		}))
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "inactive_border_color",
			value = G.default_general_col_inactive_border,
		}))
		transparency_disabled[ws.id] = false
	else
		hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity_override", value = 1 }))
		hl.dispatch(hl.dsp.window.set_prop({ prop = "opacity_inactive_override", value = 1 }))
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "active_border_color",
			value = G.custom_general_col_active_border,
		}))
		hl.dispatch(hl.dsp.window.set_prop({
			prop = "inactive_border_color",
			value = G.custom_general_col_inactive_border,
		}))
		transparency_disabled[ws.id] = true
	end
end

local zoom = 1.0
M.change_zoom = function(delta)
	return function()
		zoom = math.max(1.0, zoom + delta)

		hl.config({
			cursor = {
				zoom_factor = zoom,
				zoom_rigid = false,
				zoom_detached_camera = true,
				zoom_disable_aa = true,
			},
			binds = {
				pass_mouse_when_bound = false,
				scroll_event_delay = 0,
			},
		})
	end
end

---@param keys_list string[]
---@param dispatcher HL.Dispatcher|function
---@param opts? HL.BindOptions
M.multibind = function(keys_list, dispatcher, opts)
	for _, value in ipairs(keys_list) do
		hl.bind(value, dispatcher, opts)
	end
end

return M
