-- ============================================================================
-- TITLE : lsp
-- ABOUT : configuration for the native neovim support for lsp's
-- ============================================================================

local M = {}

-- LSP on attach keymaps
function M.on_attach(_, bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
	vim.keymap.set("n", "<leader>X", vim.diagnostic.open_float)
	vim.keymap.set("n", "<leader>td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, { buffer = bufnr, desc = "Toggle Diagnostics Signs" })
end

function M.setup()
	-- Enable LSP for nvim-cmp autocompletion (Filenames at the lsp folder)
	local lsp_configs = vim.fn.readdir(vim.fn.stdpath("config") .. "/lsp")
	for _, filename in ipairs(lsp_configs) do
		local name = vim.fs.basename(filename):gsub("%.lua$", "")
		vim.lsp.enable(name)
	end

	-- Custom Diagnostic Severity Icons
	local diagnostic_signs = {
		Error = "",
		Warn = "",
		Hint = "",
		Info = "",
	}

	-- Diagnostics
	vim.diagnostic.config({
		severity_sort = true,
		virtual_lines = {
			current_line = true,
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
				[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
				[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
				[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
			},
		},
	})
end

return M
