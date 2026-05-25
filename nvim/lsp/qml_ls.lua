-- ============================================================================
-- TITLE : qmlls (Qt QML Language Server)
-- ABOUT : Language server for QML (Qt Quick)
-- LINKS :
--   > qt : https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "qmlls" },

	filetypes = { "qml" },

	root_markers = {
		".qmlls.ini",
		"qmldir",
		".git",
	},
}
