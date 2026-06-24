-- ============================================================================
-- TITLE: keymaps
-- ABOUT: sets some quality-of-life keymaps
-- ============================================================================

local U = require("utils.vim")

-- Better window navigation - Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", "<CMD>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<CMD>split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", "<CMD>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<CMD>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<CMD>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<CMD>vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Better J behavior
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Tab managements
vim.keymap.set("n", "<leader>T", "<CMD>tabnew<CR>")
vim.keymap.set("n", "<leader>W", "<CMD>tabclose<CR>")
vim.keymap.set("n", "<leader>O", "<CMD>tabonly<CR>")

-- Toggle Inlay hints
vim.keymap.set("n", "<leader>i", function()
	local enabled = vim.lsp.inlay_hint.is_enabled()
	vim.lsp.inlay_hint.enable(not enabled)
end, { desc = "Toggle Inlay Hints" })

-- Toggle Undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
	require("undotree").open({
		command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
	})
end, { desc = "[U]ndotree toggle" })

-- Vim Pack
vim.keymap.set("n", "<leader>U", function()
	vim.pack.update()
end, { desc = "Update vim.pack plugins" })
vim.keymap.set("n", "<leader>P", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "Manage vim.pack plugins" })

-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_parent(vim.v.count1)
	else
		vim.lsp.buf.selection_range(vim.v.count1)
	end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
	if vim.treesitter.get_parser(nil, nil, { error = false }) then
		require("vim.treesitter._select").select_child(vim.v.count1)
	else
		vim.lsp.buf.selection_range(-vim.v.count1)
	end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

-- Manage Argument List
vim.keymap.set("n", "<leader>h", "<CMD>argadd %<CR>", { desc = "Add to Argument list" })
vim.keymap.set("n", "<leader>H", "<CMD>args<CR>", { desc = "Delete from Argument list" })

for i = 1, 10 do
	local key = tostring(i % 10)
	vim.keymap.set(
		"n",
		"<leader>" .. key,
		"<CMD>argu " .. i .. "<CR>",
		{ desc = string.format("Go to argument %d", i) }
	)
end

-- Custom utilities
vim.keymap.set("n", "<leader>l", "<CMD>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Replaces without losing copy register" })
vim.keymap.set("n", "<leader>o", "<CMD>only<CR>", { desc = "Focus on current buffer" })
vim.keymap.set("n", "<leader>R", "<CMD>restart<CR>", { desc = "Restart Neovim" })
vim.keymap.set("n", "<leader>K", function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end, { desc = "Closes all buffers and reopens last" })

-- Expand visual selection
vim.keymap.set("v", "<leader>e", function()
	local selection = U.get_visual_selection()
	local res = vim.fn.expand(selection)
	vim.api.nvim_paste(res, true, -1)
end, { desc = "Expand visual selection" })

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
vim.keymap.set("v", "<leader>x", function()
	local selection = U.get_visual_selection()
	local eval = load("return " .. selection, nil, "t", eval_env)()
	local res
	if type(eval) == "table" then
		res = vim.inspect(eval)
	else
		res = tostring(eval)
	end
	vim.api.nvim_paste(res, true, -1)
end, { desc = "Eval lua visual selection" })

-- Toogles floating terminal
local term_buf = nil
local term_win = nil
local function toggle_float_term()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end

	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		term_buf = vim.api.nvim_create_buf(false, true)
		term_win = U.open_floating_win(term_buf)
		vim.fn.jobstart(vim.o.shell, { term = true })
	else
		term_win = U.open_floating_win(term_buf)
	end

	vim.cmd.startinsert()
end
vim.keymap.set("n", "<A-i>", toggle_float_term)
vim.keymap.set("i", "<A-i>", function()
	vim.cmd.stopinsert()
	toggle_float_term()
end)
vim.keymap.set("t", "<A-i>", function()
	vim.cmd.stopinsert()
	toggle_float_term()
end)
