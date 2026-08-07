-- ============================================================================
-- TITLE : nvim-treesitter
-- ABOUT : The nvim-treesitter plugin provides functions for installing, updating, and removing tree-sitter parsers; a collection of queries for enabling tree-sitter features built into Neovim for these languages; a staging ground for treesitter-based features considered for upstreaming to Neovim.
-- ============================================================================

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})

-- Requires tree-sitter-cli
require("nvim-treesitter").install({
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

-- Green visual highlight on all floating windows
vim.api.nvim_create_autocmd("FileType", {
	pattern = "mason",
	callback = function()
		local win = vim.api.nvim_get_current_win()
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			vim.wo[win].winhighlight = "Visual:Search"
		end
	end,
})

-- ============================================================================
-- TITLE : SchemaStore.nvim
-- ABOUT : A Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.
-- ============================================================================
vim.pack.add({ "https://github.com/b0o/schemastore.nvim" })
