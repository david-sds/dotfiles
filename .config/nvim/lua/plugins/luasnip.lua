-- ============================================================================
-- TITLE : LuaSnip
-- ABOUT : Parse LSP-Style Snippets either directly in Lua, as a VSCode package or a SnipMate snippet collection.
-- LINKS :
--   > github : https://github.com/L3MON4D3/LuaSnip
-- ============================================================================

return {
	"L3MON4D3/LuaSnip",
	build = "make install_jsregexp",
	keys = {
		{
			"<C-y>",
			function()
				local ls = require("luasnip")
				if ls.expandable() then
					ls.expand()
				end
			end,
			mode = "i",
			desc = "Expand snippet",
		},
		{
			"<C-n>",
			function()
				require("luasnip").jump(1)
			end,
			mode = { "i", "s" },
			desc = "Next snippet jump",
		},
		{
			"<C-p>",
			function()
				require("luasnip").jump(-1)
			end,
			mode = { "i", "s" },
			desc = "Prev snippet jump",
		},
		{
			"<C-e>",
			function()
				local ls = require("luasnip")
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end,
			mode = { "i", "s" },
			desc = "Cycle snippet choice",
		},
	},
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
		require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })
	end,
}
