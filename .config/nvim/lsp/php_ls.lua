-- ============================================================================
-- TITLE : phpactor
-- ABOUT : Main PHP Language Server for refactoring and introspection.
-- LINKS :
--   > github : https://github.com/phpactor/phpactor
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "phpactor", "language-server", "-vvv" },

	filetypes = { "php" },

	root_dir = vim.fs.root(0, {
		".git",
		"composer.json",
		".phpactor.json",
		".phpactor.yml",
	}) or vim.fn.expand("%:p:h"),

	workspace_required = false,

	init_options = {
		["language_server_phpstan.enabled"] = false,
		["language_server_psalm.enabled"] = false,
	},
}
