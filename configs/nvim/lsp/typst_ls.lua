-- ============================================================================
-- TITLE : tinymist
-- ABOUT : Tinymist is an integrated language service for Typst.
-- LINKS : https://github.com/Myriad-Dreamin/tinymist
-- ============================================================================

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "tinymist" },

	filetypes = { "typst" },

	root_markers = { ".git" },

	settings = {
		formatterMode = "typstyle",
		exportPdf = "onType",
		semanticTokens = "disable",
	},
}
