-- ============================================================================
-- TITLE : nvim-colorizer.lua
-- ABOUT : A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
-- LINKS :
--   > github : https://github.com/catgoose/nvim-colorizer.lua
-- ============================================================================

return {
	"catgoose/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			user_default_options = {
				AARRGGBB = true,
			},
		})
	end,
}
