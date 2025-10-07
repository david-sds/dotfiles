local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "vscode-eslint-language-server", "--stdio" },

	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},

	root_markers = {
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml",
		"package.json",
	},

	settings = {
		eslint = {
			-- format = { enable = true },
			validate = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			-- packageManager = "npm",
			quiet = false,
		},
	},
}
