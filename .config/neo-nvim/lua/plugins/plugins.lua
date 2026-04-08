vim.pack.add({
	"https://github.com/b0o/schemastore.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/ibhagwan/fzf-lua",
})
require("nvim-tree").setup()
vim.keymap.set(
  "n",
  "<leader>e",
  "<CMD>NvimTreeToggle<CR>",
  { desc = "Toogle Nvim Tree" }
)

vim.pack.add({"https://github.com/ibhagwan/fzf-lua"})
vim.keymap.set(
  "n",
  "<leader>ff",
  function() require("fzf-lua").files() end,
  { desc = "FZF Files" }
)
vim.keymap.set(
  "n",
  "<leader>fg",
  function() require("fzf-lua").live_grep() end,
  { desc = "FZF Live Grep" }
)
vim.keymap.set(
  "n",
  "<leader>fa",
  function() require("fzf-lua").lsp_code_actions() end,
  { desc = "FZF Find Code Action" }
)
vim.keymap.set(
  "n",
  "<leader>fb",
  function() require("fzf-lua").buffers() end,
  { desc = "FZF Buffers" }
)
vim.keymap.set(
  "n",
  "<leader>fr",
  function() require("fzf-lua").resume() end,
  { desc = "FZF Resume previous search" }
)
vim.keymap.set(
  "n",
  "<leader>fh",
  function() require("fzf-lua").help_tags() end,
  { desc = "FZF Help Tags" }
)
vim.keymap.set(
  "n",
  "<leader>fk",
  function() require("fzf-lua").keymaps() end,
  { desc = "FZF Keybinds" }
)
vim.keymap.set(
  "n",
  "<leader>fd",
  function() require("fzf-lua").diagnostics_document() end,
  { desc = "FZF Diagnostics Document" }
)
vim.keymap.set(
  "n",
  "<leader>fD",
  function() require("fzf-lua").diagnostics_workspace() end,
  { desc = "FZF Diagnostics Workspace" }
)
vim.keymap.set(
  "n",
  "<leader>fs",
  function() require("fzf-lua").lsp_document_symbols() end,
  { desc = "FZF Document Symbols" }
)
vim.keymap.set(
  { "n", "v" },
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
{ desc = "FZF Search (Live Grep)" }
)
vim.keymap.set(
  "n",
  "<leader>gff",
  function() require("fzf-lua").git_files() end,
  { desc = "FZF Git Files" }
)
vim.keymap.set(
  "n",
  "<leader>gfd",
  function() require("fzf-lua").git_diff() end,
  { desc = "FZF Git Diffs" }
)


