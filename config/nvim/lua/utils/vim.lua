local M = {}

M.get_visual_selection = function()
	local opts = { type = vim.api.nvim_get_mode().mode }
	return vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), opts)[1]
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

-- Expand visual selection
M.expand_selection = function()
	local selection = M.get_visual_selection()
	local res = vim.fn.expand(selection)
	vim.api.nvim_paste(res, true, -1)
end

-- Eval Lua visual selection and paste result
local eval_env = {
	os = { date = os.date, time = os.time },
	vim = {
		inspect = vim.inspect,
		fn = { stdpath = vim.fn.stdpath, expand = vim.fn.expand },
	},
	tonumber = tonumber,
	tostring = tostring,
	math = math,
	string = string,
	table = table,
}
M.eval_selection = function()
	local selection = M.get_visual_selection()
	local eval = load("return " .. selection, nil, "t", eval_env)()
	local res
	if type(eval) == "table" then
		res = vim.inspect(eval)
	else
		res = tostring(eval)
	end
	vim.api.nvim_paste(res, true, -1)
end

M.close_hidden_buffers = function()
	local visible = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		visible[vim.api.nvim_win_get_buf(win)] = true
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and not visible[buf] then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end

M.increase_selection = function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end

M.decrease_selection = function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end

return M
