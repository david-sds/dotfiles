return {

	-- ============================================================================
	-- TITLE : dadbod.vim
	-- ABOUT : Dadbod is a Vim plugin for interacting with databases.
	-- LINKS :
	--   > github : https://github.com/tpope/vim-dadbod
	-- ============================================================================
	{
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
	},

	-- ============================================================================
	-- TITLE : kulala.nvim
	-- ABOUT : A fully-featured REST Client Interface for Neovim.
	-- LINKS :
	--   > github : https://github.com/mistweaverco/kulala.nvim
	--   > docs: https://neovim.getkulala.net/docs/getting-started
	-- ============================================================================
	{
		"mistweaverco/kulala.nvim",
		keys = {
			{
				"<leader>re",
				function()
					require("kulala").run()
				end,
				mode = { "n", "v" },
				desc = "Send request",
				ft = { "http", "rest" },
			},
			{
				"<leader>ra",
				function()
					require("kulala").run_all()
				end,
				mode = { "n", "v" },
				desc = "Run all requests",
				ft = { "http", "rest" },
			},
			{
				"<leader>rr",
				function()
					require("kulala").replay()
				end,
				desc = "Replay requests",
				ft = { "http", "rest" },
			},
			{
				"<leader>rs",
				function()
					require("kulala").set_selected_env()
				end,
				desc = "Set selected Kulala environment",
				mode = "n",
				ft = { "http", "rest" },
			},
			{
				"<leader>ri",
				function()
					require("kulala").inspect()
				end,
				desc = "Inspect response",
				mode = "n",
				ft = { "http", "rest" },
			},
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			default_env = "local",
		},
	},
}
