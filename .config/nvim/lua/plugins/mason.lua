-- ================================================================================================
-- TITLE : mason.nvim
-- ABOUT : Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- LINKS :
--   > github : https://github.com/mason-org/mason.nvim
--   > github : https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- ================================================================================================

return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- lua
				"lua-language-server",
				"stylua",
				-- typecript / javacript
				"typescript-language-server",
				"prettierd",
				"eslint-lsp",
				-- json
				"json-lsp",
				-- prisma
				"prisma-language-server",
				-- bash
				"shfmt",
				"shellcheck",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
