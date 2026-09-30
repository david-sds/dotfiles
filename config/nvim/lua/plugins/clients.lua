local U = require("utils.vim")

-- ============================================================================
-- TITLE : dadbod.vim
-- ABOUT : Dadbod is a Vim plugin for interacting with databases.
-- ============================================================================
vim.pack.add({
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",
})

vim.g.db_ui_use_nerd_fonts = 1

vim.keymap.set("n", "<leader>db", "<CMD>tabnew | DBUI<CR>", { desc = "Open Dadbod Tab" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "mysql",
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})

U.close_with_q("dbout")

-- ============================================================================
-- TITLE : rest.nvim
-- ABOUT : A fast Neovim HTTP client written in Lua.
-- LINKS :
--   > docs: https://github.com/rest-nvim/rest.nvim
-- ============================================================================
vim.pack.add({
	"https://github.com/rest-nvim/rest.nvim",
	-- luarocks dependencies, installed from git instead
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/manoelcampos/xml2lua",
	"https://github.com/lunarmodules/lua-mimetypes",
})

-- xml2lua and mimetypes keep their modules at the repo root, not in lua/
local pack_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/"
package.path = pack_dir .. "xml2lua/?.lua;" .. pack_dir .. "lua-mimetypes/?.lua;" .. package.path

vim.g.rest_nvim = {
	ui = {
		keybinds = { prev = "H", next = "L" },
	},
}

-- rest.nvim formats response bodies with `gq`, which needs a formatprg for the body's filetype
vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function()
		vim.bo.formatprg = "jq ."
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "xml",
	callback = function()
		vim.bo.formatprg = "xmllint --format -"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http",
	callback = function()
		vim.keymap.set("n", "<leader>ke", "<CMD>Rest run<CR>", { buffer = true, desc = "Send request" })
		vim.keymap.set("n", "<leader>kr", "<CMD>Rest last<CR>", { buffer = true, desc = "Replay last request" })
		vim.keymap.set("n", "<leader>ks", "<CMD>Rest env select<CR>", { buffer = true, desc = "Select env file" })
		vim.keymap.set("n", "<leader>ki", "<CMD>Rest open<CR>", { buffer = true, desc = "Open response pane" })
	end,
})

U.close_with_q("rest_nvim_result")
