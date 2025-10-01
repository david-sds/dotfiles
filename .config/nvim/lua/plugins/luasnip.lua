return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
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
		local ls = require("luasnip")

		-- Load JSON/VSCode snippets
		require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })

		-- (optional) also load Lua snippets
		require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

		-- vim.keymap.set({ "i" }, "<C-k>", function()
		-- 	ls.expand()
		-- end, { silent = true })
		--
		-- vim.keymap.set({ "i", "s" }, "<C-n>", function()
		-- 	ls.jump(1)
		-- end, { silent = true })
		--
		-- vim.keymap.set({ "i", "s" }, "<C-p>", function()
		-- 	ls.jump(-1)
		-- end, { silent = true })
		--
		-- vim.keymap.set({ "i", "s" }, "<C-e>", function()
		-- 	if ls.choice_active() then
		-- 		ls.change_choice(1)
		-- 	end
		-- end, { silent = true })
	end,
}
