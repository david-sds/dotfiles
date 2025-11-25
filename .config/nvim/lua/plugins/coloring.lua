-- ============================================================================
-- TITLE : Color pickers/Highlighters
-- LINKS :
--   > github : https://github.com/eero-lehtinen/oklch-color-picker.nvim
--   > github : https://github.com/catgoose/nvim-colorizer.lua
--   > github : https://github.com/uga-rosa/ccc.nvim
-- ============================================================================

return {
	{
		"eero-lehtinen/oklch-color-picker.nvim",
		event = "VeryLazy",
		version = "*",
		keys = {
			{
				"<leader>C",
				function()
					require("oklch-color-picker").pick_under_cursor({ fallback_open = {} })
				end,
				desc = "Color pick under cursor",
			},
		},
		---@type oklch.Opts
		opts = {},
	},
	-- {
	-- 	"catgoose/nvim-colorizer.lua",
	-- 	config = function()
	-- 		require("colorizer").setup({
	-- 			user_default_options = {
	-- 				AARRGGBB = true,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	-- {
	-- 	"uga-rosa/ccc.nvim",
	-- 	config = function()
	-- 		local ccc = require("ccc")
	-- 		ccc.setup({
	-- 			highlighter = {
	-- 				auto_enable = true,
	-- 				lsp = true,
	-- 			},
	-- 		})
	-- 	end,
	-- 	keys = {
	-- 		{
	-- 			"<leader>cp",
	-- 			"<CMD>CccPick<CR>",
	-- 			desc = "CCC: Pick Color",
	-- 		},
	-- {
	-- 	"<leader>ct",
	-- 	"<CMD>CccHighlighterToggle<CR>",
	-- 	desc = "CCC: Toggle Highlighter",
	-- },
	-- 	},
	-- },
}
