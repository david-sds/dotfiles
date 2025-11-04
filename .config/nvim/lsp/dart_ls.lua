-- ============================================================================
-- TITLE : dart language-server
-- ABOUT : DartSdk native LSP.
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "dart", "language-server", "--protocol=lsp" },

	filetypes = { "dart" },

	root_markers = { "pubspec.yaml" },

	settings = {
		dart = {
			analysisServer = {
				enable = true,
			},
			flutter = {
				flutterSdkPath = vim.env.FLUTTER_ROOT,
			},
		},
	},
}
