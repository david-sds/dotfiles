-- ================================================================================================
-- TITLE : json-lsp
-- ABOUT : Language Server Protocol implementation for JSON.
-- LINKS :
--   > github : https://github.com/microsoft/vscode-json-languageservice
-- ================================================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "vscode-json-language-server", "--stdio" },

	filetypes = { "json", "jsonc" },

	settings = {
		json = {
			validate = { enable = true },
			format = { enable = false },
		},
	},
}
