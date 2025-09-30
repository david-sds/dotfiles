return {
	"Saghen/blink.cmp",
	version = "v0.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
	},
	opts = {
		keymap = { preset = "default" },

		snippet = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},
	},
	config = function()
		require("blink.cmp").setup({
			signature = { enabled = true },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = {
					auto_show = true,
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
					},
				},
			},
		})
	end,
}
