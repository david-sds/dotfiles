local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	cmd = { "vscode-html-language-server", "--stdio" },

	on_attach = on_attach,

	filetypes = { "html" },

	single_file_support = true,

	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
}
