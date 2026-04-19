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

require("lualine").setup({
	options = {
		icons_enabled = true,
		section_separators = { left = "", right = "" },
		component_separators = "|",
	},
})

-- ============================================================================
-- TITLE : virt-column.nvim
-- ABOUT : Display a character as the colorcolumn.
-- ============================================================================
vim.pack.add({ "https://github.com/lukas-reineke/virt-column.nvim" })
require("virt-column").setup()
