local utils = require("utils.vim")

-- ============================================================================
-- TITLE : fzf-lua
-- ABOUT : lua-based fzf wrapper and integration.
-- ============================================================================

vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons", "https://github.com/ibhagwan/fzf-lua" })

---@module "fzf-lua"
---@type fzf-lua.Config|{}
---@diagnostic disable: missing-fields
require("fzf-lua").setup({
	keymap = {
		builtin = {
			true,
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
			["<C-j>"] = "preview-down",
			["<C-k>"] = "preview-up",
		},
		fzf = {
			true,
			["ctrl-q"] = "select-all+accept",
		},
	},
	grep = {
		rg_glob = true, -- Enable glob parsing (Requires ripgrep)
	},
})
require("fzf-lua").register_ui_select()

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })

vim.keymap.set("v", "<leader>fg", function()
	local selection = utils.get_visual_selection()
	require("fzf-lua").live_grep({ search = selection })
end, { desc = "FZF Live Grep (visual)" })

vim.keymap.set("v", "<leader>fG", function()
	local selection = utils.get_visual_selection()
	require("fzf-lua").live_grep({
		search = [[\<]] .. selection .. [[\>]],
		no_esc = true,
	})
end, { desc = "FZF Grep Word (visual)" })

vim.keymap.set("n", "<leader>fa", function()
	require("fzf-lua").lsp_code_actions({
		no_resume = true,
	})
end, { desc = "FZF Find Code Action" })

vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })

vim.keymap.set("n", "<leader>fr", function()
	require("fzf-lua").resume()
end, { desc = "FZF Resume previous search" })

vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })

vim.keymap.set("n", "<leader>fk", function()
	require("fzf-lua").keymaps()
end, { desc = "FZF Keybinds" })

vim.keymap.set("n", "<leader>fd", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

vim.keymap.set("n", "<leader>fs", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "FZF Document Symbols" })

vim.keymap.set("n", "<leader>gff", function()
	require("fzf-lua").git_files()
end, { desc = "FZF Git Files" })

vim.keymap.set("n", "<leader>gfd", function()
	require("fzf-lua").git_diff()
end, { desc = "FZF Git Diffs" })

-- ============================================================================
-- TITLE : vim-tmux-navigator
-- ABOUT : Seamless navigation between Vim splits and tmux panes using the same shortcuts.
-- ============================================================================

vim.g.tmux_navigator_disable_when_zoomed = 1
vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })

vim.keymap.set("n", "<c-h>", "<CMD><C-U>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<c-j>", "<CMD><C-U>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<c-k>", "<CMD><C-U>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<c-l>", "<CMD><C-U>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<c-\\>", "<CMD><C-U>TmuxNavigatePrevious<CR>")

-- ============================================================================
-- TITLE : Harpoon
-- ABOUT : Create Color Code in neovim.
-- LINKS :
--   > github : https://github.com/ThePrimeagen/harpoon
-- ============================================================================
vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/ThePrimeagen/harpoon",
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>h", mark.add_file, { desc = "Harpoon: Add file" })
vim.keymap.set("n", "<leader>H", ui.toggle_quick_menu, { desc = "Harpoon: Toggle menu" })

for i = 1, 10 do
	local key = tostring(i % 10)
	vim.keymap.set("n", "<leader>" .. key, function()
		ui.nav_file(i)
	end, { desc = string.format("Harpoon: Go to file %d", i) })
end

vim.keymap.set("n", "<C-p>", ui.nav_prev, { desc = "Harpoon: Previous file" })
vim.keymap.set("n", "<C-n>", ui.nav_next, { desc = "Harpoon: Next file" })

-- ============================================================================
-- TITLE : oil.nvim
-- ABOUT : A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
-- ============================================================================

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	use_default_keymaps = false,
	columns = { "icon", "size", "permissions" },
	keymaps = {
		["g?"] = { "actions.show_help", mode = "n" },
		["<CR>"] = { "actions.select", mode = "n" },
		["<leader>sv"] = { "actions.select", opts = { vertical = true } },
		["<leader>sh"] = { "actions.select", opts = { horizontal = true } },
		["<C-p>"] = "actions.preview",
		["<C-q>"] = "actions.close",
		["<C-r>"] = "actions.refresh",
		["-"] = { "actions.parent", mode = "n" },
		["_"] = { "actions.open_cwd", mode = "n" },
		["`"] = { "actions.cd", mode = "n" },
		["gs"] = { "actions.change_sort", mode = "n" },
		["gx"] = { "actions.open_external", mode = "n" },
		["gy"] = { "actions.yank_entry", mode = "n" },
		["g."] = { "actions.toggle_hidden", mode = "n" },
		["g\\"] = { "actions.toggle_trash", mode = "n" },
		["gh"] = {
			"<CMD>edit $HOME<CR>",
			mode = "n",
			nowait = true,
			desc = "Go to the Home directory",
		},
		["g/"] = {
			"<CMD>edit /<CR>",
			mode = "n",
			nowait = true,
			desc = "Go to the Home directory",
		},
	},
	view_options = {
		show_hidden = true,
	},
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- ============================================================================
-- TITLE : grug-far.nvim
-- ABOUT : Find And Replace plugin for neovim
-- ============================================================================

vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

vim.keymap.set("n", "<leader>q", function()
	require("grug-far").open({ prefills = { search = "" } })
end, { desc = "GrugFar Find & Replace (grug-far.nvim)" })

vim.keymap.set("v", "<leader>q", function()
	local selection = utils.get_visual_selection()
	require("grug-far").open({ prefills = { search = selection } })
end, { desc = "Find & Replace (grug-far.nvim)" })

--- @type grug.far.OptionsOverride
require("grug-far").setup({
	startInInsertMode = false,
	keymaps = {
		close = {
			i = "<C-q>",
			n = "<leader>q",
		},
	},
})
