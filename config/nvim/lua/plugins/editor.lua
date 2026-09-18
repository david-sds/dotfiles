-- ============================================================================
-- TITLE : mini.nvim
-- ABOUT : Library of 40+ independent Lua modules.
-- ============================================================================

vim.pack.add({
	"https://github.com/echasnovski/mini.ai",
	"https://github.com/echasnovski/mini.comment",
	"https://github.com/echasnovski/mini.move",
	"https://github.com/echasnovski/mini.surround",
	"https://github.com/echasnovski/mini.cursorword",
	"https://github.com/echasnovski/mini.indentscope",
	"https://github.com/echasnovski/mini.pairs",
	"https://github.com/echasnovski/mini.trailspace",
	"https://github.com/echasnovski/mini.bufremove",
	"https://github.com/echasnovski/mini.notify",
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/echasnovski/mini.operators",
})

require("mini.ai").setup()
require("mini.comment").setup()
require("mini.move").setup()
require("mini.surround").setup()
require("mini.cursorword").setup()
require("mini.indentscope").setup()
require("mini.pairs").setup()
require("mini.trailspace").setup()
require("mini.bufremove").setup()
require("mini.notify").setup()
require("mini.icons").setup()
require("mini.operators").setup()

-- Remove indent scope on terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		vim.b[args.buf].miniindentscope_disable = true
	end,
})

-- ============================================================================
-- TITLE : conform.nvim
-- ABOUT : Lightweight yet powerful formatter plugin for Neovim.
-- ============================================================================
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	-- Custom formatter.
	formatters = {
		phpcbf = {
			command = vim.fn.expand("~/.config/composer/vendor/bin/phpcbf"),
			args = { "--standard=moodle", "--no-cache", "$FILENAME" },
			stdin = false,
			exit_codes = { 0, 1 },
		},
	},
	formatters_by_ft = {
		c = { "clang-format" },
		lua = { "stylua" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },
		json = { "prettierd" },
		jsonc = { "prettierd" },
		md = { "prettierd" },
		yaml = { "prettierd" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		http = { "kulala-fmt" },
		rest = { "kulala-fmt" },
		python = { "black" },
		-- php = { "php_cs_fixer" },
		php = { "phpcbf" },
		twig = { "djlint" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.keymap.set({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = false,
		lsp_fallback = true,
	})
end, { desc = "Format buffer" })

vim.keymap.set("n", "<leader>tf", function()
	if vim.b.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable!")
	end
end, { desc = "Toggle autoformat (buffer)" })

vim.keymap.set("n", "<leader>tF", function()
	if vim.g.disable_autoformat then
		vim.cmd("FormatEnable")
	else
		vim.cmd("FormatDisable")
	end
end, { desc = "Toggle autoformat (global)" })

-- ============================================================================
-- TITLE : oklch-color-picker.nvim
-- ABOUT : Sometimes the resolution of a cli just isn't enough
-- ============================================================================
vim.pack.add({ "https://github.com/eero-lehtinen/oklch-color-picker.nvim" })

require("oklch-color-picker").setup()

vim.keymap.set("n", "<leader>cp", function()
	require("oklch-color-picker").pick_under_cursor({ fallback_open = {} })
end, { desc = "Color pick under cursor" })

-- ============================================================================
-- TITLE : TreeSJ
-- ABOUT : Neovim plugin for splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
-- ============================================================================
vim.pack.add({ "https://github.com/wansmer/treesj" })

local tsj = require("treesj")

tsj.setup({
	use_default_keymaps = false,
	check_syntax_error = true,
	max_join_length = 1000,
	cursor_behavior = "hold",
	notify = true,
	dot_repeat = true,
	on_error = nil,
})

-- For default preset
vim.keymap.set("n", "<leader>m", require("treesj").toggle)
-- For extending default preset with `recursive = true`
vim.keymap.set("n", "<leader>M", function()
	require("treesj").toggle({ split = { recursive = true } })
end)
