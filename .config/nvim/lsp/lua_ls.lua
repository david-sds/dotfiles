-- ============================================================================
-- TITLE : lua-language-server
-- ABOUT : A language server that offers Lua language support - programmed in Lua.
-- LINKS :
--   > github : https://github.com/LuaLS/lua-language-server
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

return {
	on_attach = on_attach,

	cmd = { "lua-language-server" },

	filetypes = { "lua" },

	root_markers = { ".luarc.json", ".luarc.jsonc" },

	-- See: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua",
					vim.fn.stdpath("data") .. "/lazy/nvim-cmp/lua",
					vim.fn.stdpath("data") .. "/lazy/conform.nvim/lua",
				},
			},
		},
	},
}
