-- ============================================================================
-- TITLE : nvim-cmp
-- ABOUT : A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
-- LINKS :
--   > github : https://github.com/hrsh7th/nvim-cmp
--   > github : https://github.com/hrsh7th/cmp-nvim-lsp
--   > github : https://github.com/hrsh7th/cmp-path
--   > github : https://github.com/hrsh7th/cmp-buffer
--   > github : https://github.com/hrsh7th/cmdline
--   > github : https://github.com/L3MON4D3/LuaSnip
--   > github : https://github.com/saadparwaiz1/cmp_luasnip
--   > github : https://github.com/onsails/lspkind.nvim
-- ============================================================================

---@type LazyPluginSpec[]
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"onsails/lspkind.nvim",
		},
		config = function()
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
		end,
	},
}
