-- ============================================================================
-- TITLE : oklch-color-picker.nvim
-- ABOUT : Sometimes the resolution of a cli just isn't enough
-- LINKS :
--   > github : https://github.com/eero-lehtinen/oklch-color-picker.nvim
-- ============================================================================

return {
	{
		"eero-lehtinen/oklch-color-picker.nvim",
		event = "VeryLazy",
		version = "*",
		keys = {
			{
				"<leader>cp",
				function()
					require("oklch-color-picker").pick_under_cursor({ fallback_open = {} })
				end,
				desc = "Color pick under cursor",
			},
		},
		---@type oklch.Opts
		opts = {},
	},
}
