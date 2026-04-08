require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("plugins.grammar")
require("plugins.editor")
require("plugins.plugins")

require("config.lsp").setup()
