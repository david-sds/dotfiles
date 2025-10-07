return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim", "mason.nvim" },
	config = function()
		local none_ls = require("null-ls")

		none_ls.setup({
			sources = {
				-- Lua
				none_ls.builtins.formatting.stylua,

				-- JavaScript / TypeScript
				none_ls.builtins.formatting.prettierd,

				-- Bash / Shell
				none_ls.builtins.formatting.shfmt,
				none_ls.builtins.diagnostics.shellcheck,
			},
			on_attach = require("config.lsp").on_attach,
			debounce = 150,
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
}
