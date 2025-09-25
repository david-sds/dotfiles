local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "prisma-language-server", "--stdio" },

	filetypes = { "prisma" },

	root_markers = { "schema.prisma", "package.json", ".git" },

	settings = {
		prisma = {
			-- example settings
			prismaFmtBinPath = "", -- set if you want custom prisma-fmt binary
		},
	},
}
