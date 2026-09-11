-- Core config imports
require("core.globals")
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.misc")
require("core.argbuf")
require("core.lsp").setup()

-- Theme
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

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

-- Status line
local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local norm = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = norm.fg, bg = pms.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  t = "TERMINAL",
  R = "REPLACE",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
}

function _G._statusline()
  local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
  print(mode)
  local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
  local path = vim.b.rel_path or "%f"

  local diag = ""
  local counts = vim.diagnostic.count(0) or {}
  local labels = { " ", " ", " ", " " }
  local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
  for i = 1, 4 do
    if counts[i] and counts[i] > 0 then
      diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
    end
  end

  return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c "
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
    if root ~= "" then
      vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
      vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2)
    else
      vim.b.git_branch = nil
      vim.b.rel_path = vim.fn.expand("%:p:~")
    end
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus!")
  end,
})

vim.o.statusline = "%!v:lua._statusline()"

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
