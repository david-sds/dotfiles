-- ================================================================================================
-- TITLE : bash-language-server
-- ABOUT : A language server for Bash.
-- LINKS :
--   > github : https://github.com/bash-lsp/bash-language-server
-- ================================================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "bash-language-server", "start" },

	filetypes = { "sh", "bash", "zsh" },
}
