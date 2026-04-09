-- ============================================================================
-- TITLE : kanagawa.nvim
-- ABOUT : NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
-- LINKS :
--   > github : https://github.com/rebelot/kanagawa.nvim
-- ============================================================================
vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })
vim.cmd("colorscheme kanagawa-wave")
-- {
-- 	"polirritmico/monokai-nightasty.nvim",
-- 	-- config = function()
-- 	-- 	vim.cmd("colorscheme monokai-nightasty")
-- 	-- end,
-- },

-- ============================================================================
-- TITLE : which-key
-- ABOUT : WhichKey helps you remember your Neovim keymaps, by showing keybindings as you type.
-- LINKS :
--   > github : https://github.com/folke/which-key.nvim
-- ============================================================================
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

vim.keymap.set("n", "<leader>?", function()
	require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-- ============================================================================
-- TITLE : nvim-web-devicons
-- ABOUT : Provides Nerd Font 1 icons (glyphs) for use by Neovim plugins:
-- LINKS :
--   > github : https://github.com/nvim-tree/nvim-web-devicons
-- ============================================================================
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
require("nvim-web-devicons").setup()

-- ============================================================================
-- TITLE : lualine.nvim
-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
-- LINKS :
--   > github : https://github.com/nvim-lualine/lualine.nvim
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
-- LINKS :
--   > github : https://github.com/lukas-reineke/virt-column.nvim
-- ============================================================================
vim.pack.add({ "https://github.com/lukas-reineke/virt-column.nvim" })
require("virt-column").setup()
