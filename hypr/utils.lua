local M = {}

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

M.get_relative_workspace_id = function(diff)
	local wid = hl.get_active_workspace().id
	return ((wid + diff - 1) % 10) + 1
end

return M
