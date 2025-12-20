-- ============================================================================
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- LINKS :
--   > github : https://github.com/mfussenegger/nvim-lint
-- ============================================================================

return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
		"BufEnter",
		"BufWritePost",
		"InsertLeave",
	},
	opt = {
		linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		},
	},
}
