-- ============================================================================
-- TITLE : json-lsp
-- ABOUT : Language Server Protocol implementation for JSON.
-- LINKS :
--   > github : https://github.com/microsoft/vscode-json-languageservice
-- ============================================================================

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

local ok, schemastore = pcall(require, "schemastore")

return {
	on_attach = on_attach,

	cmd = { "vscode-json-language-server", "--stdio" },

	filetypes = { "json", "jsonc" },

	settings = {
		json = {
			schemas = ok and schemastore.json.schemas() or {},
			validate = { enable = true },
			format = { enable = false },
		},
	},
}
