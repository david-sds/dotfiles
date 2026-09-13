local M = {}

M.hledger_accounts = {}
M.hledger_accounts_source = {}
M.refresh_hledger_accounts = function()
	vim.fn.jobstart({ "hledger", "accounts" }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			M.hledger_accounts = vim.tbl_filter(function(x)
				return x ~= ""
			end, data)
		end,
	})
end
function M.hledger_accounts_source:complete(_, callback)
	local items = {}
	for _, name in ipairs(M.hledger_accounts) do
		table.insert(items, {
			label = name,
			kind = vim.lsp.protocol.CompletionItemKind.Field,
		})
	end
	callback(items)
end

return M
