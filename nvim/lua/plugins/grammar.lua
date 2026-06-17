-- ============================================================================
-- TITLE : arborist.nvim
-- ABOUT : WASM-first tree-sitter parser manager for Neovim 0.12+. Parsers install automatically when you open files. No manual steps, no maintenance.
-- ============================================================================

vim.pack.add({
	"https://github.com/arborist-ts/arborist.nvim",
})

require("arborist").setup({
	update_cadence = "manual",
	install_popular = false,
	ensure_installed = {
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
	},
	ignore = {
		"env",
	},
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
