-- ================================================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Deep buffer integration for Git
-- LINKS :
--   > github : https://github.com/lewis6991/gitsigns.nvim
-- ================================================================================================

return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	config = function()
		require("gitsigns").setup()
	end,
	keys = {
		{
			"<leader>gp",
			":Gitsigns preview_hunk<CR>",
			desc = "Preview Hunk",
		},
		{
			"<leader>gu",
			":Gitsigns reset_hunk<CR>",
			desc = "Undo Hunk",
		},
		{
			"<leader>gb",
			":Gitsigns toggle_current_line_blame<CR>",
			desc = "Toggle Blame (Current line)",
		},
	},
}
