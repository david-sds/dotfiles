-- ============================================================================
-- TITLE : pyright
-- ABOUT : A fast, standards-based language server for Python.
-- LINKS :
--    > github : https://github.com/microsoft/pyright
-- ============================================================================

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "basedpyright-langserver", "--stdio" },

	filetypes = { "python" },

	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"manage.py",
		".git",
	},

	settings = {
		basedpyright = {
			analysis = {
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
}
