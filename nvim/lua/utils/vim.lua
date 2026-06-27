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

-- Toogles floating terminal
local term_buf = nil
local term_win = nil
M.toggle_floating_term = function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end

	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		term_buf = vim.api.nvim_create_buf(false, true)
		term_win = M.open_floating_win(term_buf)
		vim.fn.jobstart(vim.o.shell, { term = true })
	else
		term_win = M.open_floating_win(term_buf)
	end

	vim.cmd.startinsert()
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
