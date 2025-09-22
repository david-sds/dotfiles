-- ================================================================================================
-- TITLE : monokai-nightasty.nvim
-- ABOUT : A dark/light theme for Neovim based on the Monokai color palette. This theme is born from a mix between the code of the great tokyonight.nvim and the palette of the flavorful vim-monokai-tasty.
-- LINKS :
--   > github : https://github.com/polirritmico/monokai-nightasty.nvim
-- ================================================================================================

return {
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme monokai-nightasty")
    end,
  },
}
