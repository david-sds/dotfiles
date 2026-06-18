-- ============================================================================
-- TITLE : auto-commands
-- ABOUT : automatically run code on defined events (e.g. save, yank)
-- ============================================================================

-- Restore last cursor position when reopening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = last_cursor_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYankGroup", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

-- Close buffer with Q
local close_q_group = vim.api.nvim_create_augroup("CloseWithQGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = close_q_group,
	pattern = {
		"nvim-undotree",
		"help",
	},
	callback = function(event)
		vim.keymap.set("n", "q", "<CMD>quit!<CR>", { buffer = event.buf, silent = true })
	end,
})

-- Help pages adjustments
local help_pages_group = vim.api.nvim_create_augroup("HelpPagesGroup", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = help_pages_group,
	callback = function()
		if vim.bo.filetype ~= "help" then
			return
		end

		vim.cmd("wincmd L")
		vim.cmd("vertical resize 85")
		vim.wo.wrap = true
	end,
})
