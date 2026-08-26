-- ============================================================================
-- TITLE : hledger-lsp
-- ABOUT : A Language Server Protocol (LSP) implementation for hledger journal files.
-- ============================================================================

-- # Linux (x86_64)
-- curl -L https://github.com/juev/hledger-lsp/releases/latest/download/hledger-lsp_linux_amd64 -o hledger-lsp
-- chmod +x hledger-lsp
-- sudo mv hledger-lsp /usr/local/bin/

local lsp_config_module = require("core.lsp")
local on_attach = lsp_config_module.on_attach

---@type vim.lsp.Config
return {
	on_attach = on_attach,

	cmd = { "hledger-lsp" },

	filetypes = { "hledger", "journal", "ledger" },

	root_markers = { ".git", "*.journal" },

	single_file_support = true,
}
