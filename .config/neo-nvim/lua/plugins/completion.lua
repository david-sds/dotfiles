-- ============================================================================
-- TITLE : LuaSnip
-- ABOUT : Parse LSP-Style Snippets either directly in Lua, as a VSCode package or a SnipMate snippet collection.
-- LINKS :
--   > github : https://github.com/L3MON4D3/LuaSnip
--	build = "make install_jsregexp",
-- ============================================================================
vim.pack.add({ "https://github.com/L3MON4D3/LuaSnip" })

vim.keymap.set("i", "<C-y>", function()
	local ls = require("luasnip")
	if ls.expandable() then
		ls.expand()
	end
end, { desc = "Expand snippet" })
vim.keymap.set({ "i", "s" }, "<C-n>", function()
	require("luasnip").jump(1)
end, { desc = "Next snippet jump" })
vim.keymap.set({ "i", "s" }, "<C-p>", function()
	require("luasnip").jump(-1)
end, { desc = "Prev snippet jump" })
vim.keymap.set({ "i", "s" }, "<C-e>", function()
	local ls = require("luasnip")
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { desc = "Cycle snippet choice" })

require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/nvim/snippets" })
require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

-- ============================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
-- LINKS :
--   > github : https://github.com/hrsh7th/nvim-cmp
-- ============================================================================

vim.pack.add({
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://github.com/onsails/lspkind.nvim",
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

---@type cmp.ConfigSchema
local opts = {

	enabled = function()
		local context = require("cmp.config.context")
		if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
			return false
		end
		if require("luasnip").in_snippet() then
			return false
		end
		return true
	end,
	completion = {
		autocomplete = { "InsertEnter", "TextChanged" },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text", -- show symbol + text
			maxwidth = 50,
			ellipsis_char = "…",
		}),
	},
	mapping = {
		["<C-Space>"] = cmp.mapping.complete(),

		["<C-n>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-p>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-e>"] = cmp.mapping(function(fallback)
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
}

cmp.setup(opts)

cmp.setup.filetype({ "sql", "mysql" }, {
	sources = {
		{ name = "buffer" },
		{ name = "vim-dadbod-completion" },
	},
})

cmp.setup.filetype({ "bash", "sh" }, {
	sources = {
		{ name = "cmdline" },
	},
})

-- ============================================================================
-- TITLE : SchemaStore.nvim
-- ABOUT : A Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.
-- LINKS :
--   > github : https://github.com/b0o/schemastore.nvim
-- ============================================================================
vim.pack.add({ "b0o/schemastore.nvim" })
