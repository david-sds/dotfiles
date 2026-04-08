-- ============================================================================
-- TITLE : twiggy_language_server
-- ABOUT : LSP for Twig templates (Symfony, etc.)
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "twiggy-language-server", "--stdio" },

	filetypes = { "twig" },

	root_markers = {
		"composer.json",
		".git",
	},

	single_file_support = true,
}
