-- Core config imports
require("core.globals")
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.misc")
require("core.argbuf")
require("core.lsp").setup()

-- Theme
require("plugins.colorscheme")

-- Enable completion automatically
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if client ~= nil and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
    end
  end,
})

-- Formatting
vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "LSP format current buffer" })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})

-- Netrw
vim.g.netrw_liststyle = 1
vim.g.netrw_banner = 0
vim.g.netrw_sort_by = "exten"
vim.keymap.set("n", "-", "<CMD>Ex<CR>", { desc = "Opens Netrw" })

-- Find and Grep
local ignore_patterns = {
  "node_modules",
  "%.git",
  "%.cache",
  "dist",
  "build",
  "%.tmp",
  "%.log",
}

function _G.native_find(text, _)
  local files = vim.fn.glob("**/*", true, true)
  local result = {}
  for _, f in ipairs(files) do
    if vim.fn.isdirectory(f) == 0 then
      local skip = false
      for _, pat in ipairs(ignore_patterns) do
        if f:match(pat) then
          skip = true
          break
        end
      end
      if not skip then
        result[#result + 1] = f
      end
    end
  end
  return vim.fn.matchfuzzy(result, text)
end

vim.opt.findfunc = "v:lua.native_find"
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.keymap.set("n", "<leader>ff", ":find ", { silent = false })

vim.keymap.set("n", "<leader>fg", function()
  vim.ui.input({ prompt = "Grep: " }, function(pattern)
    if pattern then
      vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
      vim.cmd("copen")
    end
  end)
end, { silent = true })
