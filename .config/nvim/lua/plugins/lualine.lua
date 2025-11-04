-- ============================================================================
-- TITLE : lualine.nvim
-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-lualine/lualine.nvim
-- ============================================================================

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				-- section_separators = { left = '', right = ''},
				-- section_separators = { left = "", right = "" },
				component_separators = "|",
			},
		})
	end,
}
