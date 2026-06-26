-- ============================================================================
-- TITLE : tree-sitter-manager.nvim
-- ABOUT : A lightweight Tree-sitter parser manager for Neovim.
-- ============================================================================

vim.pack.add({
	"https://github.com/romus204/tree-sitter-manager.nvim",
})

require("tree-sitter-manager").setup({
	ensure_installed = {
		"bash",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"ecma",
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
	},
	parser_dir = vim.fn.stdpath("data") .. "/site/parser",
	query_dir = vim.fn.stdpath("data") .. "/site/queries",
	highlight = true,
})

local yaml_colors = vim.api.nvim_create_augroup("YamlColors", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = yaml_colors,
	pattern = "gruvbox-material",
	callback = function()
		vim.api.nvim_set_hl(0, "@property.yaml", { link = "Green" })
		vim.api.nvim_set_hl(0, "@string.yaml", { link = "Aqua" })
		vim.api.nvim_set_hl(0, "@property.json", { link = "Green" })
		vim.api.nvim_set_hl(0, "@string.json", { link = "Aqua" })
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

-- ============================================================================
-- TITLE : SchemaStore.nvim
-- ABOUT : A Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.
-- ============================================================================
vim.pack.add({ "https://github.com/b0o/schemastore.nvim" })
