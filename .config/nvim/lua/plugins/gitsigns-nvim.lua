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
}
