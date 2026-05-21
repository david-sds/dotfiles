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

return M
