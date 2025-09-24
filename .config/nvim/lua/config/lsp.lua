local M = {}

function M.on_attach(client, bufnr)
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
	-- lsp
	--------------------------------------------------------------------------------
	-- See https://gpanders.com/blog/whats-new-in-neovim-0-11/ for a nice overview
	-- of how the lsp setup works in neovim 0.11+.

	-- This actually just enables the lsp servers.
	-- The configuration is found in the lsp folder inside the nvim config folder,
	-- so in ~.config/lsp/lua_ls.lua for lua_ls, for example.
	vim.lsp.enable("lua_ls")
	vim.lsp.enable("dartls")

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
				vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
				vim.keymap.set("i", "<C-Space>", function()
					vim.lsp.completion.get()
				end)
			end
		end,
	})

	-- Custom diagnostic severity icons
	local diagnostic_signs = {
		Error = " ",
		Warn = " ",
		Hint = "",
		Info = "",
	}

	-- Diagnostics
	vim.diagnostic.config({
		-- Use the default configuration
		-- virtual_lines = true

		-- Alternatively, customize specific options
		virtual_lines = {
			-- Only show virtual line diagnostics for the current cursor line
			current_line = true,
		},

		-- Apply custom icons for diagnostic severity
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

M.setup()

return M
