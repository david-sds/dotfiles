-- ============================================================================
-- TITLE : gruvbox-material
-- ABOUT : Gruvbox Material is a modified version of Gruvbox, the contrast is adjusted to be softer in order to protect developers' eyes.
-- ============================================================================

vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })
vim.g.gruvbox_material_background = "hard" -- hard, medium, soft
vim.g.gruvbox_material_foreground = "original" -- material, mix, original
vim.cmd("colorscheme gruvbox-material")

-- Green visual highlight on all floating windows
local float_hl_group = vim.api.nvim_create_augroup("FloatVisualHighlight", { clear = true })
vim.api.nvim_create_autocmd("WinNew", {
	group = float_hl_group,
	callback = function()
		local win = vim.api.nvim_get_current_win()
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			vim.wo[win].winhighlight = "Visual:Search"
		end
	end,
})
