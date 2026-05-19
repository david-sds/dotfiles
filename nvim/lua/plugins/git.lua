-- ============================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Deep buffer integration for Git
-- ============================================================================
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup()

vim.keymap.set("n", "<leader>gu", "<CMD>Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })
vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns blame_line full=true<CR>", { desc = "Open Blame Preview" })
vim.keymap.set("n", "<leader>gB", "<CMD>Gitsigns blame<CR>", { desc = "Open Blame (Current buffer)" })
vim.keymap.set("n", "]g", "<CMD>Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
vim.keymap.set("n", "[g", "<CMD>Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
vim.keymap.set("n", "<leader>gp", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gr", function()
	require("gitsigns").detach()
	require("nvim-tree.api").tree.reload()
	require("gitsigns").attach()
end, { desc = "Reload Git" })

-- ============================================================================
-- TITLE : Diffview.nvim
-- ABOUT : Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
-- ============================================================================
vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })
