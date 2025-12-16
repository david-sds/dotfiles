-- ============================================================================
-- TITLE : kanagawa.nvim
-- ABOUT : NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
-- LINKS :
--   > github : https://github.com/rebelot/kanagawa.nvim
-- ============================================================================

return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme kanagawa-wave")
			-- vim.cmd("colorscheme kanagawa-dragon")
			-- vim.cmd("colorscheme kanagawa-lotus")
		end,
	},
	{
		"polirritmico/monokai-nightasty.nvim",
		-- config = function()
		-- 	vim.cmd("colorscheme monokai-nightasty")
		-- end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		-- config = function()
		-- 	require("rose-pine").setup({
		-- 		styles = {
		-- 			bold = true,
		-- 			italic = false,
		-- 			transparency = true,
		-- 		},
		-- 	})
		-- 	vim.cmd("colorscheme rose-pine")
		-- end,
	},
}
