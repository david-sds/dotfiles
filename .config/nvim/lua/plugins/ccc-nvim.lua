-- ============================================================================
-- TITLE : ccc.nvim
-- ABOUT : Create Color Code in neovim.
-- LINKS :
--   > github : https://github.com/uga-rosa/ccc.nvim
-- ============================================================================

return {
	"uga-rosa/ccc.nvim",
	config = function()
		local ccc = require("ccc")
		ccc.setup({
			highlighter = {
				auto_enable = true,
				lsp = true,
			},
		})
	end,
	keys = {
		{
			"<leader>cp",
			"<CMD>CccPick<CR>",
			desc = "CCC: Pick Color",
		},
		{
			"<leader>ct",
			"<CMD>CccHighlighterToggle<CR>",
			desc = "CCC: Toggle Highlighter",
		},
	},
}
