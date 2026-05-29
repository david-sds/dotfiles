-- ============================================================================
-- TITLE : LuaSnip
-- ABOUT : Parse LSP-Style Snippets either directly in Lua, as a VSCode package or a SnipMate snippet collection.
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
-- TITLE : supermaven-nvim
-- ABOUT : A neovim plugin for superman-style autocompletion
-- ============================================================================

vim.pack.add({
	"https://github.com/Exafunction/windsurf.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/hrsh7th/nvim-cmp",
})

local codeium = require("codeium")
codeium.setup({
	virtual_text = {
		enabled = false,
		manual = true,
		idle_delay = 300,
		key_bindings = {
			accept = "<C-g>",
		},
		filetypes = {
			ledger = false,
			c = false,
		},
	},
})
codeium.s.enabled = false

vim.keymap.set("n", "<leader>tc", "<CMD>Codeium Toggle<CR>", { desc = "Toggle Codeium" })

-- ============================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
-- ============================================================================

vim.pack.add({
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-path",
	-- "https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/saadparwaiz1/cmp_luasnip",
	"https://github.com/onsails/lspkind.nvim",
})

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

local function fetch_hledger_accounts()
	local f = io.popen("hledger accounts")
	if not f then
		return {}
	end

	local accounts = {}
	for line in f:lines() do
		if line ~= "" then
			table.insert(accounts, line)
		end
	end

	f:close()
	return accounts
end

local hledger_accounts_source = {}
function hledger_accounts_source:complete(_, callback)
	local hledger_accounts = fetch_hledger_accounts()
	local items = {}
	for _, name in ipairs(hledger_accounts) do
		table.insert(items, {
			label = name,
			kind = vim.lsp.protocol.CompletionItemKind.Field,
		})
	end
	callback(items)
end

cmp.register_source("hledger_accounts", hledger_accounts_source)

---@type cmp.ConfigSchema
local opts = {
	enabled = function()
		local context = require("cmp.config.context")
		if context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment") then
			return false
		end
		return true
	end,
	completion = {
		autocomplete = {
			cmp.TriggerEvent.InsertEnter,
			cmp.TriggerEvent.TextChanged,
		},
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
		{ name = "codeium" },
		-- { name = "buffer" },
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
			if cmp.visible() then
				cmp.abort()
			elseif luasnip.choice_active() then
				luasnip.change_choice(1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
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
	sources = cmp.config.sources({
		{ name = "cmdline" },
	}, cmp.get_config().sources),
})

cmp.setup.filetype("ledger", {
	sources = {
		{ name = "hledger_accounts" },
	},
})

-- ============================================================================
-- TITLE : SchemaStore.nvim
-- ABOUT : A Neovim plugin that provides the SchemaStore catalog for use with jsonls and yamlls.
-- ============================================================================
vim.pack.add({ "https://github.com/b0o/schemastore.nvim" })
