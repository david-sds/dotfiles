-- ============================================================================
-- TITLE : gitsigns.nvim
-- ABOUT : Deep buffer integration for Git
-- LINKS :
--   > github : https://github.com/lewis6991/gitsigns.nvim
-- ============================================================================
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup()

vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "Undo Hunk" })
vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Blame (Current line)" })
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })
vim.keymap.set("n", "]g", ":Gitsigns next_hunk<CR>", { desc = "Next Hunk" })
vim.keymap.set("n", "[g", ":Gitsigns prev_hunk<CR>", { desc = "Previous Hunk" })
vim.keymap.set("n", "<leader>gr", function()
	require("gitsigns").detach()
	require("nvim-tree.api").tree.reload()
	require("gitsigns").attach()
end, { desc = "Reload Git" })

-- ============================================================================
-- TITLE : vim-fugitive
-- ABOUT : Fugitive is the premier Vim plugin for Git. Or maybe it's the premier Git plugin for Vim? Either way, it's "so awesome, it should be illegal". That's why it's called Fugitive.
-- LINKS :
--   > github : https://github.com/tpope/vim-fugitive
-- ============================================================================
vim.pack.add({ "https://github.com/tpope/vim-fugitive" })

vim.keymap.set("n", "<leader>gB", ":Git blame<CR>", { desc = "Open Blame (Current buffer)" })
vim.keymap.set("n", "<leader>gD", ":Gdiffsplit!<CR>", { desc = "Show Git Diffs" })
vim.keymap.set("n", "<leader>gH", ":0GcLog<CR>", { desc = "Show Git History (Current buffer)" })
vim.keymap.set(
	{ "n", "v" },
	"<leader>gh",
	":normal! V<CR>j?<<<<<<<<CR>ok/>>>>>>><CR>:'<,'>diffget //2<CR>",
	{ desc = "Get the hunk in the left" }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>gl",
	":normal! V<CR>j?<<<<<<<<CR>ok/>>>>>>><CR>:'<,'>diffget //3<CR>",
	{ desc = "Get the hunk in the right" }
)
