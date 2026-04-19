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
vim.keymap.set("n", "<leader>fa", function()
	require("fzf-lua").lsp_code_actions()
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
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fD", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })
vim.keymap.set("n", "<leader>fs", function()
	require("fzf-lua").lsp_document_symbols()
end, { desc = "FZF Document Symbols" })
vim.keymap.set({ "n", "v" }, "<leader>fS", function()
	local mode = vim.api.nvim_get_mode().mode
	local search_term

	if mode == "v" or mode == "V" or mode == "\22" then
		local opts = { type = mode }
		local selection = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), opts)
		search_term = selection[1]
	else
		search_term = vim.fn.expand("<cword>")
	end

	require("fzf-lua").live_grep({ search = search_term })
end, { desc = "FZF Search (Live Grep)" })
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

vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })

vim.keymap.set("n", "<c-h>", "<cmd><C-U>TmuxNavigateLeft<CR>")
vim.keymap.set("n", "<c-j>", "<cmd><C-U>TmuxNavigateDown<CR>")
vim.keymap.set("n", "<c-k>", "<cmd><C-U>TmuxNavigateUp<CR>")
vim.keymap.set("n", "<c-l>", "<cmd><C-U>TmuxNavigateRight<CR>")
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<CR>")

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
	vim.keymap.set("n", key, function()
		ui.nav_file(i)
	end, { desc = string.format("Harpoon: Go to file %d", i) })
end

vim.keymap.set("n", "<C-p>", ui.nav_prev, { desc = "Harpoon: Previous file" })
vim.keymap.set("n", "<C-n>", ui.nav_next, { desc = "Harpoon: Next file" })

-- ============================================================================
-- TITLE : nvim-tree.lua
-- ABOUT : A file explorer tree for Neovim, written in Lua.
-- ============================================================================
vim.pack.add({ "https://github.com/nvim-tree/nvim-tree.lua" })

require("nvim-tree").setup({
	git = {
		enable = true,
		timeout = 1000,
	},
	filters = {
		dotfiles = false,
		git_ignored = false,
	},
	view = {
		width = 40,
		preserve_window_proportions = true,
		adaptive_size = true,
		relativenumber = true,
	},
	update_focused_file = {
		enable = true,
		update_cwd = false,
	},
})

vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeToggle<CR>", { desc = "Toogle Nvim Tree" })
vim.keymap.set("n", "<leader>ti", function()
	require("nvim-tree.api").filter.git.ignored.toggle()
end, { desc = "Toggle GitIgnored files (nvim-tree)" })

-- ============================================================================
-- TITLE : oil.nvim
-- ABOUT : A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
-- ============================================================================

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup()

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- ============================================================================
-- TITLE : replacer.nvim
-- ABOUT : replacer.nvim makes quickfix windows editable, allowing changes to both the content of a file and its path.
-- ============================================================================

vim.pack.add({ "https://github.com/gabrielpoca/replacer.nvim" })

vim.keymap.set("n", "<leader>q", function()
	require("replacer").run()
end, { desc = "Edit Quickfix buffer" })
