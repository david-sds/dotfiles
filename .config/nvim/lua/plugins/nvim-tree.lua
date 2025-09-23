-- ================================================================================================
-- TITLE : nvim-tree.lua
-- ABOUT : A file explorer tree for Neovim, written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================================

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
  keys = {
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
				dotfiles = false, -- Show hidden files (dotfiles)
			},
			view = {
				adaptive_size = true,
			},
		})
	end,
}
