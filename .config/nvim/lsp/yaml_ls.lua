-- ================================================================================================
-- TITLE : yaml-language-server
-- ABOUT : Language Server for YAML Files.
-- LINKS :
--   > github : https://github.com/redhat-developer/yaml-language-server
-- ================================================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

local schemastore = require("schemastore")

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "yaml-language-server", "--stdio" },

	filetypes = { "yaml", "yml" },

	settings = {
		yaml = {
			schemas = schemastore.yaml.schemas(),
			validate = true,
			format = {
				enable = true,
			},
		},
	},
}
