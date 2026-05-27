-- ============================================================================
-- TITLE : gruvbox-material
-- ABOUT : Gruvbox Material is a modified version of Gruvbox, the contrast is adjusted to be softer in order to protect developers' eyes.
-- ============================================================================

vim.pack.add({ "https://github.com/sainnhe/gruvbox-material" })
vim.g.gruvbox_material_background = "hard" -- hard, medium, soft
vim.g.gruvbox_material_foreground = "original" -- material, mix, original
vim.cmd("colorscheme gruvbox-material")
