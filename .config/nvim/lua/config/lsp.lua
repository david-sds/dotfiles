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
	-- Enable LSP for nvim-cmp autocompletion (Filenames at the lsp folder)
	vim.lsp.enable("bash_ls")
	vim.lsp.enable("css_ls")
	vim.lsp.enable("dart_ls")
	vim.lsp.enable("emmet_ls")
	vim.lsp.enable("eslint_ls")
	vim.lsp.enable("html_ls")
	vim.lsp.enable("json_ls")
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("php_ls")
	vim.lsp.enable("prisma_ls")
	vim.lsp.enable("python_ls")
	vim.lsp.enable("twiggy_ls")
	vim.lsp.enable("typescript_ls")
	vim.lsp.enable("yaml_ls")
	vim.lsp.enable("markdown_ls")

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
