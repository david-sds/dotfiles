return {

	-- ============================================================================
	-- TITLE : kanagawa.nvim
	-- ABOUT : NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
	-- LINKS :
	--   > github : https://github.com/rebelot/kanagawa.nvim
	-- ============================================================================
	{
		{
			"rebelot/kanagawa.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme kanagawa-wave")
				-- vim.cmd("colorscheme kanagawa-dragon")
				-- vim.cmd("colorscheme kanagawa-lotus")
			end,
		},
		-- {
		-- 	"polirritmico/monokai-nightasty.nvim",
		-- 	-- config = function()
		-- 	-- 	vim.cmd("colorscheme monokai-nightasty")
		-- 	-- end,
		-- },
	},

	-- ============================================================================
	-- TITLE : which-key
	-- ABOUT : WhichKey helps you remember your Neovim keymaps, by showing keybindings as you type.
	-- LINKS :
	--   > github : https://github.com/folke/which-key.nvim
	-- ============================================================================
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- ============================================================================
	-- TITLE : nvim-web-devicons
	-- ABOUT : Provides Nerd Font 1 icons (glyphs) for use by Neovim plugins:
	-- LINKS :
	--   > github : https://github.com/nvim-tree/nvim-web-devicons
	-- ============================================================================
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- ============================================================================
	-- TITLE : lualine.nvim
	-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
	-- LINKS :
	--   > github : https://github.com/nvim-lualine/lualine.nvim
	-- ============================================================================
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					section_separators = { left = "", right = "" },
					component_separators = "|",
				},
			})
		end,
	},

	-- ============================================================================
	-- TITLE : virt-column.nvim
	-- ABOUT : Display a character as the colorcolumn.
	-- LINKS :
	--   > github : https://github.com/lukas-reineke/virt-column.nvim
	-- ============================================================================
	{ "lukas-reineke/virt-column.nvim", opts = {} },
}
