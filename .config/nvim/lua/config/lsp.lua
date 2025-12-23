-- ============================================================================
-- TITLE : Neovim LSP
-- ABOUT : Configuration for the native Neovim support for LSP's.
-- ============================================================================

local M = {}

function M.on_attach(_, bufnr)
	local buf_map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	buf_map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
	buf_map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
	buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
	buf_map("n", "gr", vim.lsp.buf.references, "Go to References")
	buf_map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
end

function M.setup()
	-- Get the path nvim/lua/lsp directory and enable all LSPs
	local lsp_dir = vim.fn.stdpath("config") .. "/lua/lsp"
	if vim.fn.isdirectory(lsp_dir) == 1 then
		local files = vim.fn.split(vim.fn.globpath(lsp_dir, "*.lua"), "\n")
		for _, file in ipairs(files) do
			local server_name = vim.fn.fnamemodify(file, ":t:r")
			vim.lsp.enable(server_name)
		end
	end

	-- Custom Diagnostic Severity Icons
	local diagnostic_signs = {
		Error = " ",
		Warn = " ",
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

return M
