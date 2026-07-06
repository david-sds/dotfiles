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
vim.keymap.set("n", "<leader>Q", "<CMD>wqa!<CR>", { desc = "Write and Quit all named buffers" })
vim.keymap.set("n", "<leader>K", U.close_hidden_buffers, { desc = "Close all hidden buffers" })
vim.keymap.set("v", "<leader>x", U.expand_selection, { desc = "Expand visual selection" })
vim.keymap.set("v", "<leader>e", U.eval_selection, { desc = "Eval lua visual selection" })
vim.keymap.set({ "n", "i", "v", "t" }, "<A-CR>", U.toggle_floating_term, { desc = "Toggles floating terminal" })
vim.keymap.set({ "n", "x", "o" }, "<A-o>", U.increase_selection, { desc = "Select parent node" })
vim.keymap.set({ "n", "x", "o" }, "<A-i>", U.decrease_selection, { desc = "Select child node" })
