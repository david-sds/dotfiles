-- ================================================================================================
-- TITLE : kulala.nvim
-- ABOUT : A fully-featured REST Client Interface for Neovim.
-- LINKS :
--   > github : https://github.com/mistweaverco/kulala.nvim
--   > docs: https://neovim.getkulala.net/docs/getting-started
-- ================================================================================================

return {
	"mistweaverco/kulala.nvim",
	keys = {
		{
			"<leader>re",
			function()
				require("kulala").run()
			end,
			mode = { "n", "v" },
			desc = "Send request",
		},
		{
			"<leader>ra",
			function()
				require("kulala").run_all()
			end,
			mode = { "n", "v" },
			desc = "Run all requests",
		},
		{
			"<leader>rr",
			function()
				require("kulala").replay()
			end,
			desc = "Replay requests",
		},
		{ -- Set selected Kulala environment
			"<leader>rs",
			function()
				require("kulala").set_selected_env()
			end,
			desc = "Set selected Kulala environment",
			mode = "n",
		},
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = false,
	},
}
