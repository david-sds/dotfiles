-- ============================================================================
-- TITLE : dadbod.vim
-- ABOUT : Dadbod is a Vim plugin for interacting with databases.
-- ============================================================================
vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})

vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>db", "<CMD>DBUIToggle<CR>", { desc = "Toggle Dadbod UI" })

-- ============================================================================
-- TITLE : kulala.nvim
-- ABOUT : A fully-featured REST Client Interface for Neovim.
-- LINKS :
--   > docs: https://neovim.getkulala.net/docs/getting-started
-- ============================================================================

vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

require("kulala").setup({
	global_keymaps = false,
	default_env = "local",
})

vim.keymap.set({ "n", "v" }, "<leader>re", function()
	require("kulala").run()
end, { desc = "Send request" })
vim.keymap.set({ "n", "v" }, "<leader>ra", function()
	require("kulala").run_all()
end, { desc = "Run all requests" })
vim.keymap.set("n", "<leader>rr", function()
	require("kulala").replay()
end, { desc = "Replay requests" })
vim.keymap.set("n", "<leader>rs", function()
	require("kulala").set_selected_env()
end, { desc = "Set selected Kulala environment" })
vim.keymap.set("n", "<leader>ri", function()
	require("kulala").inspect()
end, { desc = "Inspect response" })
