-- ============================================================================
-- TITLE : pyright
-- ABOUT : A fast, standards-based language server for Python.
-- LINKS :
--    > github : https://github.com/microsoft/pyright
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "pyright-langserver", "--stdio" },

	filetypes = { "python" },

	-- root_markers = {
	-- 	"pyproject.toml",
	-- 	".git",
	-- 	"setup.py",
	-- 	"setup.cfg",
	-- 	"requirements.txt",
	-- },

	settings = {
		python = {
			analysis = {
				use = "languageServer",
				typeCheckingMode = "basic", -- Or "strict"
				autoSearchPaths = true,
				diagnosticMode = "workspace",
			},
		},
	},
}
