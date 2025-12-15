-- ============================================================================
-- TITLE : codecompanion.nvim
-- ABOUT : Code with LLMs and Agents via the in-built adapters, the community adapters or by building your own.
-- LINKS :
--   > github : https://github.com/olimorris/codecompanion.nvim
-- ============================================================================

return {
	"olimorris/codecompanion.nvim",
	cmd = {
		"CodeCompanion",
		"CodeCompanionActions",
		"CodeCompanionChat",
		"CodeCompanionCmd",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "codecompanion" },
		},
	},
	opts = {
		strategies = {
			chat = {
				adapter = "gemini",
			},
			inline = {
				adapter = "gemini",
			},
		},
		gemini = function()
			return require("codecompanion.adapters").extend("gemini", {
				schema = {
					model = {
						default = "gemini-2.5-flash-native-audio-dialog",
					},
				},
			})
		end,
	},
	keys = {
		{
			"<leader>ka",
			"<CMD>CodeCompanionActions<CR>",
			desc = "Open CodeCompanionActions",
			mode = { "n", "v" },
		},
		{
			"<leader>kk",
			"<CMD>CodeCompanionChat Toggle<CR>",
			desc = "Toggle CodeCompanionChat",
			mode = { "n", "v" },
		},
		{
			"<leader>ki",
			"<CMD>CodeCompanion<CR>",
			desc = "Inline Prompt CodeCompanion",
			mode = { "n", "v" },
		},
		{
			"<leader>ke",
			"<CMD>CodeCompanion Explain<CR>",
			desc = "Explain selected code",
			mode = { "n", "v" },
		},
		{
			"<leader>kf",
			"<CMD>CodeCompanion Fix<CR>",
			desc = "Propose fixes for selected code",
			mode = { "n", "v" },
		},
		{
			"<leader>kc",
			"<CMD>CodeCompanionChat Clear<CR>",
			desc = "Clear CodeCompanionChat history",
			mode = { "n", "v" },
		},
	},
}
