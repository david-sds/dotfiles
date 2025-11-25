-- ============================================================================
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- LINKS :
--   > github : https://github.com/mfussenegger/nvim-lint
-- ============================================================================

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({
			"BufEnter", -- When opening a buffer or moving into it
			"BufWritePost", -- When saving a buffer
			"InsertLeave", -- When leaving insert mode in a buffer
		}, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
