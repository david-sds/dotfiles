local M = {}

M.get_visual_selection = function()
	local opts = { type = vim.api.nvim_get_mode().mode }
	return vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), opts)[1]
end

M.open_floating_win = function(buf)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	return vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
	})
end

-- Close buffer with Q
local close_q_group = vim.api.nvim_create_augroup("CloseWithQGroup", { clear = true })
M.close_with_q = function(pattern)
	vim.api.nvim_create_autocmd("FileType", {
		group = close_q_group,
		pattern = pattern,
		callback = function(event)
			vim.keymap.set("n", "q", "<CMD>quit!<CR>", { buffer = event.buf, silent = true })
		end,
	})
end

return M
