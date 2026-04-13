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

	root_dir = function(bufnr, on_dir)
		if not lsp_config_module.is_real_file_buffer(bufnr) then
			return
		end

		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(fname, { "pubspec.yaml" }) or vim.fs.dirname(fname))
	end,

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
