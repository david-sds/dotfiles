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
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

vim.keymap.set({ "n", "v" }, "<leader>F", function()
	require("conform").format({
		async = false,
		lsp_fallback = true,
	})
end, { desc = "Format buffer" })

-- ============================================================================
-- TITLE : oklch-color-picker.nvim
-- ABOUT : Sometimes the resolution of a cli just isn't enough
-- ============================================================================
vim.pack.add({ "https://github.com/eero-lehtinen/oklch-color-picker.nvim" })

require("oklch-color-picker").setup()

vim.keymap.set("n", "<leader>cp", function()
	require("oklch-color-picker").pick_under_cursor({ fallback_open = {} })
end, { desc = "Color pick under cursor" })

vim.pack.add({ "https://github.com/wansmer/treesj" })

local tsj = require("treesj")

local langs = {--[[ configuration for languages ]]
}

tsj.setup({
	---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
	use_default_keymaps = true,
	---@type boolean Node with syntax error will not be formatted
	check_syntax_error = true,
	---If line after join will be longer than max value,
	---@type number If line after join will be longer than max value, node will not be formatted
	max_join_length = 120,
	---Cursor behavior:
	---hold - cursor follows the node/place on which it was called
	---start - cursor jumps to the first symbol of the node being formatted
	---end - cursor jumps to the last symbol of the node being formatted
	---@type 'hold'|'start'|'end'
	cursor_behavior = "hold",
	---@type boolean Notify about possible problems or not
	notify = true,
	---@type boolean Use `dot` for repeat action
	dot_repeat = true,
	---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
	on_error = nil,
	---@type table Presets for languages
	-- langs = {}, -- See the default presets in lua/treesj/langs
})
