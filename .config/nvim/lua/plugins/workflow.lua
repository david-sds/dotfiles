return {
	-- ============================================================================
	-- TITLE : fzf-lua
	-- ABOUT : lua-based fzf wrapper and integration.
	-- LINKS :
	--   > github : https://github.com/ibhagwan/fzf-lua
	-- ============================================================================
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		---@module "fzf-lua"
		---@type fzf-lua.Config|{}
		---@diagnostic disable: missing-fields
		opts = {
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			grep = {
				rg_glob = true, -- Enable glob parsing (Requires ripgrep)
			},
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "FZF Files",
			},
			{
				"<leader>fg",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "FZF Live Grep",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "FZF Buffers",
			},
			{
				"<leader>fr",
				function()
					require("fzf-lua").resume()
				end,
				desc = "FZF Resume previous search",
			},
			{
				"<leader>fh",
				function()
					require("fzf-lua").help_tags()
				end,
				desc = "FZF Help Tags",
			},
			{
				"<leader>fk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "FZF Keybinds",
			},
			{
				"<leader>fd",
				function()
					require("fzf-lua").diagnostics_document()
				end,
				desc = "FZF Diagnostics Document",
			},
			{
				"<leader>fD",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "FZF Diagnostics Workspace",
			},
			{
				"<leader>fs",
				function()
					require("fzf-lua").lsp_document_symbols()
				end,
				desc = "FZF Document Symbols",
			},
			{
				"<leader>fS",
				function()
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
				end,
				mode = { "n", "v" },
				desc = "FZF Search (Live Grep)",
			},
			{
				"<leader>gff",
				function()
					require("fzf-lua").git_files()
				end,
				desc = "FZF Git Files",
			},
			{
				"<leader>gfd",
				function()
					require("fzf-lua").git_diff()
				end,
				desc = "FZF Git Diffs",
			},
		},
	},

	-- ============================================================================
	-- TITLE : vim-tmux-navigator
	-- ABOUT : Seamless navigation between Vim splits and tmux panes using the same shortcuts.
	-- LINKS :
	--   > github : https://github.com/christoomey/vim-tmux-navigator
	-- ============================================================================
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	-- ============================================================================
	-- TITLE : undotree
	-- ABOUT : Undotree visualizes the undo history and makes it easy to browse and switch between different undo branches.
	-- LINKS :
	--   > github : https://github.com/mbbill/undotree
	-- ============================================================================
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				"<Cmd>UndotreeToggle<CR>",
				desc = "Toggle Undotree",
			},
		},
	},

	-- ============================================================================
	-- TITLE : Harpoon
	-- ABOUT : Create Color Code in neovim.
	-- LINKS :
	--   > github : https://github.com/ThePrimeagen/harpoon
	-- ============================================================================
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
		end,
		keys = {
			{
				"<leader>h",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon: Add file",
			},
			{
				"<leader>H",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon: Toggle quick menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon: Go to file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon: Go to file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon: Go to file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon: Go to file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "Harpoon: Go to file 5",
			},
			{
				"<leader>6",
				function()
					require("harpoon"):list():select(6)
				end,
				desc = "Harpoon: Go to file 6",
			},
			{
				"<leader>7",
				function()
					require("harpoon"):list():select(7)
				end,
				desc = "Harpoon: Go to file 7",
			},
			{
				"<leader>8",
				function()
					require("harpoon"):list():select(8)
				end,
				desc = "Harpoon: Go to file 8",
			},
			{
				"<leader>9",
				function()
					require("harpoon"):list():select(9)
				end,
				desc = "Harpoon: Go to file 9",
			},
			{
				"<leader>0",
				function()
					require("harpoon"):list():select(0)
				end,
				desc = "Harpoon: Go to file 0",
			},
			{
				"<C-p>",
				function()
					require("harpoon"):list():prev()
				end,
				mode = "n",
				desc = "Harpoon: Go to previous file",
			},
			{
				"<C-n>",
				function()
					require("harpoon"):list():next()
				end,
				mode = "n",
				desc = "Harpoon: Go to next file",
			},
		},
	},

	-- ============================================================================
	-- TITLE : nvim-tree.lua
	-- ABOUT : A file explorer tree for Neovim, written in Lua.
	-- LINKS :
	--   > github : https://github.com/nvim-tree/nvim-tree.lua
	-- ============================================================================
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		keys = {
			{
				"<leader>e",
				"<Cmd>NvimTreeToggle<CR>",
				desc = "Toggle File Explorer",
			},
			{
				"<leader>gi",
				function()
					require("nvim-tree.api").tree.toggle_gitignore_filter()
				end,
				desc = "Toggle GitIgnored files (nvim-tree)",
			},
		},
		config = function()
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
		end,
	},

	-- ============================================================================
	-- TITLE : oil.nvim
	-- ABOUT : A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
	-- LINKS :
	--   > github : https://github.com/stevearc/oil.nvim
	-- ============================================================================
	{
		"stevearc/oil.nvim",
		opts = {},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
		},
	},

	-- ============================================================================
	-- TITLE : replacer.nvim
	-- ABOUT : replacer.nvim makes quickfix windows editable, allowing changes to both the content of a file and its path.
	-- LINKS :
	--   > github : https://github.com/gabrielpoca/replacer.nvim
	-- ============================================================================
	{
		"gabrielpoca/replacer.nvim",
		keys = {
			{
				"<leader>qr",
				function()
					require("replacer").run()
				end,
				desc = "Edit Quickfix buffer",
			},
		},
	},
}
