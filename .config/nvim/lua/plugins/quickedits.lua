return {
	{
		"stevearc/oil.nvim",
		opts = {},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
	},
	{
		"gabrielpoca/replacer.nvim",
		keys = {
			{
				"<leader>qr",
				function()
					require("replacer").run()
				end,
				desc = "Edit Quickfix buffer",
			},
		},
	},
}
