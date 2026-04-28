-- ============================================================================
-- TITLE : kanagawa.nvim
-- ABOUT : NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
-- ============================================================================

vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })
vim.g.gruvbox_material_background = "hard" -- hard, medium, soft
vim.g.gruvbox_material_foreground = "original" -- material, mix, original
vim.cmd("colorscheme gruvbox-material")

-- vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
-- vim.cmd("colorscheme kanagawa-wave")

-- vim.pack.add({ "https://github.com/polirritmico/monokai-nightasty.nvim" })
-- vim.cmd("colorscheme monokai-nightasty")

-- vim.pack.add({ "https://github.com/tahayvr/vhs80.nvim" })
-- vim.cmd.colorscheme("vhs80")

-- ============================================================================
-- TITLE : which-key
-- ABOUT : WhichKey helps you remember your Neovim keymaps, by showing keybindings as you type.
-- ============================================================================
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

require("which-key").setup()

-- ============================================================================
-- TITLE : nvim-web-devicons
-- ABOUT : Provides Nerd Font 1 icons (glyphs) for use by Neovim plugins:
-- ============================================================================
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
require("nvim-web-devicons").setup()

-- ============================================================================
-- TITLE : lualine.nvim
-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
-- ============================================================================
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

-- Prefix special buffer with URI scheme
local function smart_filename()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" then
		return "[No Name]"
	end

	local filename = name:match("([^/]+)$")

	if vim.fn.filereadable(name) == 1 then
		return filename
	end

	local scheme = name:match("^([%w_+-]+)://") or "buffer"
	return scheme .. "://" .. filename
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		section_separators = { left = "", right = "" },
		component_separators = "|",
	},
	sections = {
		lualine_c = { smart_filename },
	},
})
