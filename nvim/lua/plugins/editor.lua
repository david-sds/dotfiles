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

-- ============================================================================
-- TITLE : conform.nvim
-- ABOUT : Lightweight yet powerful formatter plugin for Neovim.
-- ============================================================================
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
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
		php = { "php_cs_fixer" },
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
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- ============================================================================
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

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
-- TITLE : render-markdown.nvim
-- ABOUT : Plugin to improve viewing Markdown files in Neovim
--
-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
--
-- ============================================================================
vim.pack.add({
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

---@module 'render-markdown'
-- -@type render.md.UserConfig
require("render-markdown").setup()

vim.keymap.set(
	"n",
	"<leader>tm",
	"<CMD>RenderMarkdown toggle<CR>",
	{ desc = "Toogle RenderMarkdown (render-markdown.nvim)" }
)
