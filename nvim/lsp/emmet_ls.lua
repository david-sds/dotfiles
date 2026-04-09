-- ============================================================================
-- TITLE : emmet_language_server
-- ABOUT : Better Emmet support using VS Code's helper
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "emmet-language-server", "--stdio" },

	filetypes = {
		"html",
		"css",
		"scss",
		"javascriptreact",
		"typescriptreact",
		"twig",
		"php",
		"vue",
	},

	root_markers = { ".git", "composer.json", "package.json" },

	init_options = {
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = true,
	},
}
