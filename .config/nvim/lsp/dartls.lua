local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_dir = vim.fs.root(0, { "pubspec.yaml" }), -- This is crucial for recognizing your project root
	settings = {
		dart = {
			analysisServer = {
				enable = true,
			},
			flutter = {
				flutterSdkPath = vim.env.FLUTTER_ROOT, -- Optional: If you need to explicitly point to your Flutter SDK
			},
		},
	},
}
