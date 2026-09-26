-- ============================================================================
-- TITLE : qmlls (Qt QML Language Server)
-- ABOUT : Language server for QML (Qt Quick)
-- LINKS :
--   > qt : https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
-- ============================================================================

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	-- System qmlls (matches the installed Qt 6); plain "qmlls" resolves to Mason's
	-- outdated standalone build, since Mason's bin comes first in PATH.
	cmd = { "qmlls6", "-d", "/usr/share/doc/qt6" },

	filetypes = { "qml" },

	root_markers = {
		".qmlls.ini",
		"qmldir",
		".git",
	},
}
