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
vim.keymap.set("n", "<leader>U", vim.pack.update, { desc = "Update vim.pack plugins" })
vim.keymap.set("n", "<leader>P", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "Manage vim.pack plugins" })

-- Manage Argument List
local argsdir = "~/.local/share/nvim/argsdir" -- args directory path
local argsdir_path = vim.fn.expand(argsdir)
if vim.fn.isdirectory(argsdir_path) == 0 then
	vim.fn.mkdir(argsdir_path, "p") -- Create if not exists
end
local path = argsdir_path .. "/" .. vim.fn.getcwd():gsub("/", "_")

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	callback = function()
		local current_path = argsdir_path .. "/" .. vim.fn.getcwd():gsub("/", "_")
		if vim.fn.filereadable(current_path) == 0 then
			return
		end
		vim.cmd("silent! 1,$argdelete")
		local lines = vim.fn.readfile(current_path)
		for _, arg in ipairs(lines) do
			vim.cmd("argadd " .. arg)
		end
	end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
	pattern = "arglist://",
	callback = function()
		local buf = vim.fn.bufnr("arglist://")
		if buf == -1 then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local clean_lines = {}
		for _, line in ipairs(lines) do
			local l = line:gsub("%s+$", "")
			if l ~= "" then
				table.insert(clean_lines, l)
			end
		end

		vim.cmd("args " .. table.concat(clean_lines, " "))
		vim.fn.writefile(clean_lines, path)

		vim.bo[buf].modified = false
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_close(win, true)
		vim.api.nvim_buf_delete(buf, { force = true })
	end,
})

local function open_arglist_buffer()
	local args = vim.fn.argv()
	if type(args) == "string" then
		args = { args }
	end
	if #args == 0 then
		vim.notify("Arglist empty")
	end

	local buf_name = "arglist://"
	local buf = vim.fn.bufnr(buf_name)
	if buf == -1 then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, buf_name)
	else
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
	end

	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = buf,
		once = true,
		callback = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})

	vim.bo[buf].buftype = "acwrite"
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, args)

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
		if line == "" then
			return
		end
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
		vim.cmd("e " .. line)
	end, { buffer = buf, nowait = true, silent = true })

	local width = math.floor(vim.o.columns * 0.5)
	local height = math.floor(vim.o.lines * 0.5)
	return vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
	})
end

local function add_new_arg()
	local file = vim.fn.expand("%:p")
	local args = vim.fn.argv()
	if type(args) == "string" then
		args = { args }
	end
	for _, arg in ipairs(args) do
		if vim.fn.fnamemodify(arg, ":p") == file then
			return
		end
	end
	vim.cmd("argadd " .. file)
	args = vim.fn.argv()
	if type(args) == "string" then
		args = { args }
	end
	vim.fn.writefile(args, path)
end

vim.keymap.set("n", "<leader>h", add_new_arg, { desc = "Add to Argument list" })
vim.keymap.set("n", "<leader>H", open_arglist_buffer, { desc = "Open argument edit buffer" })

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
vim.keymap.set("n", "<leader>Q", "<CMD>wqa!<CR>", { desc = "Write and Quit all named buffers" })
vim.keymap.set("n", "<leader>K", U.close_hidden_buffers, { desc = "Close all hidden buffers" })
vim.keymap.set("v", "<leader>x", U.expand_selection, { desc = "Expand visual selection" })
vim.keymap.set("v", "<leader>e", U.eval_selection, { desc = "Eval lua visual selection" })
-- vim.keymap.set({ "n", "i", "v", "t" }, "<M-q>", U.toggle_floating_term, { desc = "Toggles floating terminal" })
vim.keymap.set({ "n", "x", "o" }, "<M-o>", U.increase_selection, { desc = "Select parent node" })
vim.keymap.set({ "n", "x", "o" }, "<M-i>", U.decrease_selection, { desc = "Select child node" })
