-- ============================================================================
-- TITLE : conform.nvim
-- ABOUT : Lightweight yet powerful formatter plugin for Neovim.
-- LINKS :
--   > github : https://github.com/stevearc/conform.nvim
-- ============================================================================

return {
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
}
