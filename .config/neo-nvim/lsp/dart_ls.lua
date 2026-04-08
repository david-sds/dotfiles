-- ============================================================================
-- TITLE : dart language-server
-- ABOUT : DartSdk native LSP.
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	on_init = function(client)
		client.server_capabilities.semanticTokensProvider = nil
	end,

	cmd = { "dart", "language-server", "--protocol=lsp" },

	filetypes = { "dart" },

	root_markers = { "pubspec.yaml" },

	settings = {
		dart = {
			flutter = {
				flutterSdkPath = vim.env.FLUTTER_ROOT,
			},
			analysisServer = {
				enable = true,
			},
			updateImportsOnRename = true,
		},
	},
}
