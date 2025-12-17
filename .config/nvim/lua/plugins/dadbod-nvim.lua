-- ============================================================================
-- TITLE : kulala.nvim
-- ABOUT : A fully-featured REST Client Interface for Neovim.
-- LINKS :
--   > github : https://github.com/kristijanhusak/vim-dadbod-ui
--   > github : https://github.com/tpope/vim-dadbod
--   > github : https://github.com/mistweaverco/kulala.nvim
-- ============================================================================

return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
		keys = {
			{
				"<leader>db",
				"<CMD>DBUIToggle<CR>",
				desc = "Toggle Dadbod UI",
			},
		},
	},
}
