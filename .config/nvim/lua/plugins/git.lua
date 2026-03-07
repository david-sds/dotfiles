return {

	-- ============================================================================
	-- TITLE : gitsigns.nvim
	-- ABOUT : Deep buffer integration for Git
	-- LINKS :
	--   > github : https://github.com/lewis6991/gitsigns.nvim
	-- ============================================================================
	{
		"lewis6991/gitsigns.nvim",
		-- Attach before loading and before creating buffers
		event = { "BufReadPre", "BufNewFile" },
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
	},

	-- ============================================================================
	-- TITLE : vim-fugitive
	-- ABOUT : Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git plugin for Vim? Either way, it's "so awesome, it should be illegal". That's why it's called Fugitive.
	-- LINKS :
	--   > github : https://github.com/tpope/vim-fugitive
	-- ============================================================================
	{
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
		},
	},
}
