-- ============================================================================
-- TITLE : lsp
-- ABOUT : configuration for the native neovim support for lsp's
-- ============================================================================

local M = {}

function M.on_attach(_, bufnr)
	local buf_map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	buf_map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
	buf_map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
	buf_map("n", "gr", vim.lsp.buf.references, "Go to References")
	buf_map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
	buf_map("n", "<leader>td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, "Toggle Diagnostics Signs")
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

function M.is_real_file_buffer(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	return name ~= nil and name ~= "" and vim.startswith(name, "/")
end

return M
