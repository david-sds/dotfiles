-- ============================================================================
-- TITLE : marksman
-- ABOUT : Language server for Markdown providing completion, sections navigation, and cross-references.
-- LINKS :
--   > github : https://github.com/artempyanykh/marksman
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "marksman", "server" },

	filetypes = { "markdown", "markdown.mdx" },

	root_markers = { ".marksman.toml", ".git" },

	workspace_required = false,

	settings = {},
}
