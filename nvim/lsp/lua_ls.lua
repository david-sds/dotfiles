-- ============================================================================
-- TITLE : lua-language-server
-- ABOUT : A language server that offers Lua language support - programmed in Lua.
-- LINKS :
--   > github : https://github.com/LuaLS/lua-language-server
-- ============================================================================

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

local function core_pack_library(plugin_names)
	local library = {
		vim.fn.expand("$VIMRUNTIME/lua"),
		vim.fn.stdpath("config") .. "/lua",
	}
	local core_pack = vim.fn.stdpath("data") .. "/site/pack/core/opt/"

	for _, plugin_name in ipairs(plugin_names) do
		local plugin_dir = core_pack .. plugin_name
		local lua_dir = plugin_dir .. "/lua"

		if vim.fn.isdirectory(lua_dir) == 1 then
			table.insert(library, lua_dir)
		elseif vim.fn.isdirectory(plugin_dir) == 1 then
			table.insert(library, plugin_dir)
		end
	end

	return library
end

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
				checkThirdParty = false,
				library = core_pack_library({
					"nvim-tree.lua",
					"lazy.nvim",
					"nvim-cmp",
					"conform.nvim",
					"oklch-color-picker.nvim",
					"fzf-lua",
				}),
			},
		},
	},
}
