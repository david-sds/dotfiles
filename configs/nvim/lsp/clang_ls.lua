-- ============================================================================
-- TITLE : clangd
-- ABOUT : Language server for C/C++/Obj-C.
-- LINKS :
--   > github : https://github.com/clangd/clangd
-- ============================================================================

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "clangd" },

	filetypes = {
		"c",
		"cpp",
	},

	root_markers = {
		".git",
		"compile_commands.json",
	},
}
