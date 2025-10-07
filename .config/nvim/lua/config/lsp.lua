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

	-- Check out the docs for more options:
	-- :help vim.lsp
	-- :help vim.lsp.buf
	-- :help vim.lsp.diagnostic
	-- :help vim.diagnostic
end

function M.setup()
	-- Enable LSP for nvim-cmp autocompletion support (Requires filenames at the lsp folder)
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local capabilities = cmp_nvim_lsp.default_capabilities()
	for _, server in ipairs({
		"dart_ls",
		"json_ls",
		"lua_ls",
		"prisma_ls",
		"typescript_ls",
		"eslint_ls",
	}) do
		vim.lsp.enable(server, { capabilities = capabilities, on_attach = M.on_attach })
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
