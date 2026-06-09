-- ============================================================================
-- TITLE : nvim-treesitter
-- ABOUT : The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality such as highlighting based on it.
-- ============================================================================
vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

-- Requires tree-sitter-cli
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
	"prisma",
	"commonlisp",
	"ledger",
	"qmljs",
	"typst",
})

-- Start Treesitter automatically for every filetype buffer.
local ts_group = vim.api.nvim_create_augroup("TreesitterStartGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = ts_group,
	pattern = "*",
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- ============================================================================
-- TITLE : mason.nvim
-- ABOUT : Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- ============================================================================
vim.pack.add({
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason-tool-installer").setup({
	ensure_installed = {
		-- c
		"clangd",
		"clang-format",
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
		-- qml
		"qmlls",
		-- typst
		"tinymist",
	},
	auto_update = false,
	run_on_start = true,
})
require("mason").setup()

vim.keymap.set("n", "<leader>M", "<CMD>Mason<CR>", { desc = "Open Mason menu" })
