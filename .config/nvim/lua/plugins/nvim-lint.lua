return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			sh = { "shellcheck" },
			bash = { "shellcheck" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({
			"BufEnter", -- When opening a buffer or moving into it
			"BufWritePost", -- When saving a buffer
			"InsertLeave", -- When leaving insert mode in a buffer
		}, {
			group = lint_augroup,
			callback = function()
				-- executed when a event is triggered
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger [L]int" })
	end,
}
