-- ============================================================================
-- TITLE : nvim-treesitter
-- ABOUT : The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality such as highlighting based on it.
-- ============================================================================
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})
require("nvim-treesitter").install({
	"c",
	"bash",
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"javascript",
	"typescript",
	"dart",
	"json",
	"http",
	"xml",
	"twig",
	"php",
	"phpdoc",
	"yaml",
	"toml",
	"sql",
	"java",
})

vim.keymap.set(
	"n",
	"<leader>tt",
	"<CMD>TSContext toggle<CR>",
	{ desc = "Toggle Treesitter Context (nvim-treesitter-context)" }
)

-- ============================================================================
-- TITLE : mason.nvim
-- ABOUT : Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- ============================================================================
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	{ src = "https://github.com/williamboman/mason.nvim", name = "mason-gui" },
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- lua
		"lua-language-server",
		"stylua",
		-- typecript / javacript
		"typescript-language-server",
		"prettierd",
		"eslint-lsp",
		-- html
		"html-lsp",
		-- css
		"css-lsp",
		-- json
		"json-lsp",
		"jq",
		-- python
		"pyright",
		"black",
		-- prisma
		"prisma-language-server",
		-- bash
		"bash-language-server",
		"shfmt",
		-- markdown
		"marksman",
		-- yaml
		"yaml-language-server",
		--- kulala
		"kulala-fmt",
		-- php
		"phpactor",
		"php-cs-fixer",
		"phpstan",
		-- twig
		"twiggy-language-server",
		"twig-cs-fixer",
		-- emmet
		"emmet-language-server",
	},
	auto_update = false,
	run_on_start = true,
})
require("mason").setup()

-- ============================================================================
-- TITLE : trouble.nvim
-- ABOUT : A pretty diagnostics, references, quickfix and location list viewer for Neovim.
-- ============================================================================
vim.pack.add({ "https://github.com/folke/trouble.nvim" })

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Workspace Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

require("trouble").setup()
