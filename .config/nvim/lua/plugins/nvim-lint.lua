-- ============================================================================
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- LINKS :
--   > github : https://github.com/mfussenegger/nvim-lint
-- ============================================================================

return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			php = { "phpstan" },
		}

		vim.api.nvim_create_autocmd({
			"BufReadPre",
			"BufNewFile",
			"BufEnter",
			"BufWritePost",
			"InsertLeave",
		}, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
