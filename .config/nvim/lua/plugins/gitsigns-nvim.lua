-- ============================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Deep buffer integration for Git
-- LINKS :
--   > github : https://github.com/lewis6991/gitsigns.nvim
-- ============================================================================

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup()
	end,
	keys = {
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
		{
			"<leader>gp",
			":Gitsigns preview_hunk<CR>",
			desc = "Preview Hunk",
		},
		{
			"]g",
			":Gitsigns next_hunk<CR>",
			desc = "Next Hunk",
		},
		{
			"[g",
			":Gitsigns prev_hunk<CR>",
			desc = "Previous Hunk",
		},
		{
			"<leader>gr",
			function()
				require("gitsigns").detach()
				require("nvim-tree.api").tree.reload()
				require("gitsigns").attach()
			end,
			desc = "Reload Git",
		},
	},
}
