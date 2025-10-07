-- ================================================================================================
-- TITLE : prisma-language-server
-- ABOUT : Any editor that is compatible with the Language Server Protocol can create clients that can use the features provided by this language server.
-- LINKS : https://github.com/prisma/language-tools
-- ================================================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "prisma-language-server", "--stdio" },

	filetypes = { "prisma" },

	root_markers = { "schema.prisma", "package.json", ".git" },

	settings = {
		prisma = {
			prismaFmtBinPath = "",
		},
	},
}
