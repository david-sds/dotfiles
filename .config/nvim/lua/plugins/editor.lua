return {
	-- ============================================================================
	-- TITLE : mini.nvim
	-- ABOUT : Library of 40+ independent Lua modules.
	-- LINKS :
	--   > github : https://github.com/echasnovski/mini.nvim
	-- ============================================================================
	{
		{ "echasnovski/mini.ai", version = "*", opts = {} },
		{ "echasnovski/mini.comment", version = "*", opts = {} },
		{ "echasnovski/mini.move", version = "*", opts = {} },
		{ "echasnovski/mini.surround", version = "*", opts = {} },
		{ "echasnovski/mini.cursorword", version = "*", opts = {} },
		{ "echasnovski/mini.indentscope", version = "*", opts = {} },
		{ "echasnovski/mini.pairs", version = "*", opts = {} },
		{ "echasnovski/mini.trailspace", version = "*", opts = {} },
		{ "echasnovski/mini.bufremove", version = "*", opts = {} },
		{ "echasnovski/mini.notify", version = "*", opts = {} },
		{ "echasnovski/mini.icons", version = "*", opts = {} },
		{ "echasnovski/mini.operators", version = "*", opts = {} },
	},

	-- ============================================================================
	-- TITLE : conform.nvim
	-- ABOUT : Lightweight yet powerful formatter plugin for Neovim.
	-- LINKS :
	--   > github : https://github.com/stevearc/conform.nvim
	-- ============================================================================
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescript = { "prettierd" },
					typescriptreact = { "prettierd" },
					json = { "prettierd" },
					md = { "prettierd" },
					yaml = { "prettierd" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					http = { "kulala-fmt" },
					rest = { "kulala-fmt" },
					python = { "black" },
					php = { "php_cs_fixer" },
					-- twig = { "djlint" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({
						async = false,
						lsp_fallback = true,
					})
				end,
				desc = "Format buffer",
				mode = { "n", "v" },
			},
		},
	},

	-- ============================================================================
	-- TITLE : nvim-lint
	-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
	-- LINKS :
	--   > github : https://github.com/mfussenegger/nvim-lint
	-- ============================================================================
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				php = { "phpstan" },
			}

			vim.api.nvim_create_autocmd({
				"BufReadPre",
				"BufNewFile",
				"BufEnter",
				"BufWritePost",
				"InsertLeave",
			}, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- ============================================================================
	-- TITLE : oklch-color-picker.nvim
	-- ABOUT : Sometimes the resolution of a cli just isn't enough
	-- LINKS :
	--   > github : https://github.com/eero-lehtinen/oklch-color-picker.nvim
	-- ============================================================================
	{
		{
			"eero-lehtinen/oklch-color-picker.nvim",
			event = "VeryLazy",
			version = "*",
			keys = {
				{
					"<leader>cp",
					function()
						require("oklch-color-picker").pick_under_cursor({ fallback_open = {} })
					end,
					desc = "Color pick under cursor",
				},
			},
			---@type oklch.Opts
			opts = {},
		},
	},
}
