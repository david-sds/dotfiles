-- ============================================================================
-- TITLE : trouble.nvim
-- ABOUT : A pretty diagnostics, references, quickfix and location list viewer for Neovim.
-- ============================================================================
vim.pack.add({ "https://github.com/folke/trouble.nvim" })

vim.keymap.set("n", "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Workspace Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<CMD>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<CMD>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

---@type trouble.Config
require("trouble").setup({})

-- Darkens background color of trouble.nvim buffer (gruvbox-material)
local trouble_colors_group = vim.api.nvim_create_augroup("TroubleColorsGroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = trouble_colors_group,
	callback = function()
		vim.api.nvim_set_hl(0, "TroubleNormal", { link = "NvimTreeNormal" })
		vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "NvimTreeNormalNC" })
	end,
})

-- ============================================================================
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- ============================================================================
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

-- Custom linter.
lint.linters.phpcs.cmd = vim.fn.expand("~/.config/composer/vendor/bin/phpcs")
lint.linters.phpcs.args = {
	"-q",
	"--standard=Moodle",
	"--report=json",
	"-",
}
lint.linters_by_ft = {
	-- php = { "phpstan" },
	php = { "phpcs" },
}

-- Attempts to lint buffer
local try_lint_group = vim.api.nvim_create_augroup("TryLintGroup", { clear = true })
vim.api.nvim_create_autocmd({
	"BufReadPre",
	"BufNewFile",
	"BufEnter",
	"BufWritePost",
	"InsertLeave",
}, {
	group = try_lint_group,
	callback = function()
		lint.try_lint()
	end,
})
