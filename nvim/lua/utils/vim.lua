local M = {}

M.get_visual_selection = function()
	local opts = { type = vim.api.nvim_get_mode().mode }
	return vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), opts)[1]
end

return M
