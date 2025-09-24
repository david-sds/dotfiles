require("config.lazy")

local function format_lua_file()
  -- Get the current buffer's file path.
  local file = vim.fn.expand("%:p")

  -- Use vim.fn.system() to run stylua on the file.
  local formatted_text = vim.fn.system({ "stylua", file })

  -- If the command succeeded, replace the buffer's content.
  if vim.v.shell_error == 0 then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(formatted_text, "\n"))
  end
end

-- Create a user command to run the function.
vim.api.nvim_create_user_command("StyLuaFormat", format_lua_file, { nargs = 0, desc = "Format current Lua file with StyLua" })
