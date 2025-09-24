return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      -- This maps the `lua` filetype to the `stylua` formatter.
      formatters_by_ft = {
        lua = { "stylua" },
      },
      -- This option makes formatting happen automatically on save.
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
