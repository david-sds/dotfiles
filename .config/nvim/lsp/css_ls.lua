-- ================================================================================================
-- TITLE : css-lsp
-- ABOUT : Language Server Protocol implementation for CSS, SCSS & LESS.
-- LINKS :
--   > github : https://github.com/microsoft/vscode-css-languageservice
-- ================================================================================================

---@type vim.lsp.Config
return {
	cmd = { "vscode-css-language-server", "--stdio" },

	filetypes = { "css", "scss", "less" },

	init_options = { provideFormatter = true },

	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}
