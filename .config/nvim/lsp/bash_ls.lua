local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "bash-language-server", "start" },

	filetypes = { "sh", "bash", "zsh" },
}
