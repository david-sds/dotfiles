local U = require("utils.vim")

-- ============================================================================
-- TITLE : dadbod.vim
-- ABOUT : Dadbod is a Vim plugin for interacting with databases.
-- ============================================================================
vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})

vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>db", "<CMD>tabnew | DBUI<CR>", { desc = "Open Dadbod Tab" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "mysql",
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})

U.close_with_q("dbout")

-- ============================================================================
-- TITLE : kulala.nvim
-- ABOUT : A fully-featured REST Client Interface for Neovim.
-- LINKS :
--   > docs: https://neovim.getkulala.net/docs/getting-started
-- ============================================================================

vim.pack.add({ "https://github.com/mistweaverco/kulala.nvim" })

require("kulala").setup({
	default_env = "local",
	global_keymaps = false,
	kulala_keymaps = {
		false,
		["Show verbose"] = false,
		["Show headers"] = false,
		["Show body"] = false,
		["Show script output"] = false,
		["Show report"] = false,
		["Previous tab"] = {
			"H",
			function()
				require("kulala.ui").show_previous_tab()
			end,
			mode = { "n" },
		},
		["Next tab"] = {
			"L",
			function()
				require("kulala.ui").show_next_tab()
			end,
			mode = { "n" },
		},
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function()
		vim.keymap.set({ "n", "v" }, "<leader>ke", function()
			require("kulala").run()
		end, { desc = "Send request" })
		vim.keymap.set({ "n", "v" }, "<leader>ka", function()
			require("kulala").run_all()
		end, { desc = "Run all requests" })
		vim.keymap.set("n", "<leader>kr", function()
			require("kulala").replay()
		end, { desc = "Replay requests" })
		vim.keymap.set("n", "<leader>ks", function()
			require("kulala").set_selected_env()
		end, { desc = "Set selected Kulala environment" })
		vim.keymap.set("n", "<leader>ki", function()
			require("kulala").inspect()
		end, { desc = "Inspect response" })
		vim.keymap.set("n", "<leader>kk", function()
			require("kulala").scripts_clear_global()
		end, { desc = "Clear global cache" })
	end,
})
