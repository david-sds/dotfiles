-- ================================================================================================
-- TITLE : mason.nvim
-- ABOUT : Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
-- LINKS :
--   > github : https://github.com/mason-org/mason.nvim
-- ================================================================================================

return {
	"mason-org/mason.nvim",
	opts = {
		ensure_installed = {
			"lua-language-server",
			"stylua",
			"typescript-language-server",
			"prettierd",
			"prisma-language-server",
		},
	},
}
