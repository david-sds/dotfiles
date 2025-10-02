-- ================================================================================================
-- TITLE : fzf-lua
-- ABOUT : lua-based fzf wrapper and integration.
-- LINKS :
--   > github : https://github.com/ibhagwan/fzf-lua
-- ================================================================================================

return {
	"ibhagwan/fzf-lua",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
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
			"<leader>fh",
			function()
				require("fzf-lua").help_tags()
			end,
			desc = "FZF Help Tags",
		},
		{
			"<leader>fx",
			function()
				require("fzf-lua").diagnostics_document()
			end,
			desc = "FZF Diagnostics Document",
		},
		{
			"<leader>fX",
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
				require("fzf-lua").lsp_workspace_symbols()
			end,
			desc = "FZF Workspace Symbols",
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
			desc = "FZF Git Files",
		},
	},
}
