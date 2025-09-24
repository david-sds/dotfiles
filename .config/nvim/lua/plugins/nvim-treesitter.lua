-- ================================================================================================
-- TITLE : nvim-treesitter
-- ABOUT : The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality such as highlighting based on it.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ================================================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "dart",
      },
      sync_install = false,
      auto_install = true,
      ignore_install = { "javascript" },
      highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
       additional_vim_regex_highlighting = false,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {"nvim-treesitter/playground"}
}

