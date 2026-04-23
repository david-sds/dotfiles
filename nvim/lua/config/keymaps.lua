-- ============================================================================
-- TITLE: keymaps
-- ABOUT: sets some quality-of-life keymaps
-- ============================================================================

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

-- Custom utilities
vim.keymap.set("n", "<leader>l", "<CMD>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Replaces without losing copy register" })
vim.keymap.set("n", "<leader>o", "<CMD>only<CR>", { desc = "Focus on current buffer" })
vim.keymap.set("n", "<leader>R", "<CMD>restart<CR>", { desc = "Restart Neovim" })
vim.keymap.set("n", "<leader>U", function()
	vim.pack.update()
end, { desc = "Update vim.pack plugins" })
vim.keymap.set("n", "<leader>I", "<CMD>InspectTree<CR>", { desc = "Inspect Tree" })
vim.keymap.set("n", "<leader>M", "<CMD>Mason<CR>", { desc = "Open Mason menu" })

-- Undotree toggle
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
	require("undotree").open({
		command = math.floor(vim.api.nvim_win_get_width(0) / 3) .. "vnew",
	})
end, { desc = "[U]ndotree toggle" })

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
