-- ================================================================================================
-- TITLE : vim-fugitive
-- ABOUT : Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git plugin for Vim? Either way, it's "so awesome, it should be illegal". That's why it's called Fugitive.
-- LINKS :
--   > github : https://github.com/tpope/vim-fugitive
-- ================================================================================================

return {
	lazy = false,
	"tpope/vim-fugitive",
	keys = {
		{
			"<leader>gB",
			":Git blame<CR>",
			desc = "Open Blame (Current buffer)",
		},
		{
			"<leader>gD",
			":Gdiffsplit!<CR>",
			desc = "Show Git Diffs",
		},
		{
			"<leader>gH",
			":0GcLog<CR>",
			desc = "Show Git History (Current buffer)",
		},
		{
			"<leader>gh",
			":normal! V<CR>j?<<<<<<<<CR>ok/>>>>>>><CR>:'<,'>diffget //2<CR>",
			desc = "Get the hunk in the left",
			mode = { "n", "v" },
		},
		{
			"<leader>gl",
			":normal! V<CR>j?<<<<<<<<CR>ok/>>>>>>><CR>:'<,'>diffget //3<CR>",
			desc = "Get the hunk in the right",
			mode = { "n", "v" },
		},
		{
			"<leader>gg",
			function()
				vim.cmd("normal! V>")
				vim.cmd("j?<<<<<<<")
				vim.cmd("ok/>>>>>>")
			end,
		},
	},
}
