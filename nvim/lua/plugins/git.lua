-- ============================================================================
-- TITLE : vim-fugitive
-- ABOUT : Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git plugin for Vim? Either way, it's "so awesome, it should be illegal". That's why it's called Fugitive.
-- ============================================================================
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

vim.keymap.set("n", "<leader>gg", "<CMD>Git<CR>", { desc = "Show Git Summary" })
vim.keymap.set("n", "<leader>gb", "<CMD>Git blame<CR>", { desc = "Open Blame (Current buffer)" })
vim.keymap.set("n", "<leader>gd", "<CMD>Gdiffsplit!<CR>", { desc = "Show Git Diffs" })
vim.keymap.set("n", "<leader>gh", "<CMD>0GcLog<CR>", { desc = "Show Git History (Current buffer)" })

-- ============================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Deep buffer integration for Git
-- ============================================================================
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup()

vim.keymap.set("n", "<leader>gu", "<CMD>Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })
vim.keymap.set(
	"n",
	"<leader>gB",
	"<CMD>Gitsigns toggle_current_line_blame<CR>",
	{ desc = "Toggle Blame (Current line)" }
)
vim.keymap.set("n", "]g", "<CMD>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
vim.keymap.set("n", "[g", "<CMD>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
vim.keymap.set("n", "<leader>gp", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gr", function()
	require("gitsigns").detach()
	require("nvim-tree.api").tree.reload()
	require("gitsigns").attach()
end, { desc = "Reload Git" })
