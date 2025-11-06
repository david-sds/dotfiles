-- ============================================================================
-- TITLE : nvim-tree.lua
-- ABOUT : A file explorer tree for Neovim, written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-tree/nvim-tree.lua
-- ============================================================================

return {
	"nvim-tree/nvim-tree.lua",
	keys = {
		{
			"<leader>e",
			"<Cmd>NvimTreeToggle<CR>",
			desc = "Toggle File Explorer",
		},
		{
			"<leader>gi",
			function()
				require("nvim-tree.api").tree.toggle_gitignore_filter()
			end,
			desc = "Toggle GitIgnored files (nvim-tree)",
		},
	},
	config = function()
		require("nvim-tree").setup({
			filters = {
				dotfiles = false,
				git_ignored = false,
			},
			view = {
				width = 40,
				preserve_window_proportions = true,
				adaptive_size = false,
			},
			update_focused_file = {
				enable = true,
				update_cwd = false,
			},
			actions = {
				open_file = {
					resize_window = false,
				},
			},
		})
	end,
}
