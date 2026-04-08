-- ============================================================================
-- TITLE : eslint-lsp
-- ABOUT : Language Server Protocol implementation for ESLint. The server uses the ESLint library installed in the opened workspace folder. If the folder doesn't provide one the extension looks for a global install version.
-- LINKS :
--   > github : https://github.com/Microsoft/vscode-eslint
-- ============================================================================

-- Reference: https://github.com/dlvandenberg/dotfiles/blob/main/.config/nvim-11/lsp/eslint.lua

local lsp_config_module = require("config.lsp")
local on_attach = lsp_config_module.on_attach

local function insert_package_json(config_files, field, fname)
	local path = vim.fn.fnamemodify(fname, ":h")
	local root_with_package = vim.fs.find({ "package.json", "package.json5" }, { path = path, upward = true })[1]

	if root_with_package then
		-- only add package.json if it contains field parameter
		for line in io.lines(root_with_package) do
			if line:find(field) then
				config_files[#config_files + 1] = vim.fs.basename(root_with_package)
				break
			end
		end
	end
	return config_files
end

---@type vim.lsp.Config
return {
	cmd = { "vscode-eslint-language-server", "--stdio" },

	on_attach = on_attach,

	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.jsx",
		"svelte",
	},

	workspace_required = true,

	root_dir = function(bufnr, on_dir)
		local root_file_patterns = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
			"eslint.config.js",
			"eslint.config.mjs",
			"eslint.config.cjs",
			"eslint.config.ts",
			"eslint.config.mts",
			"eslint.config.cts",
		}

		local fname = vim.api.nvim_buf_get_name(bufnr)
		root_file_patterns = insert_package_json(root_file_patterns, "eslintConfig", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_file_patterns, { path = fname, upward = true })[1]))
	end,

	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = false,
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = false,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onSave",
		problems = {
			shortenToSingleLine = false,
		},
		-- nodePath configures the directory in which the eslint server should start its node_modules resolution.
		-- This path is relative to the workspace folder (root dir) of the server instance.
		nodePath = "",
		-- use the workspace folder location or the file location (if no workspace folder is open) as the working directory
		workingDirectory = { mode = "location" },
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	before_init = function(_, config)
		-- The "workspaceFolder" is a VSCode concept. It limits how far the
		-- server will traverse the file system when locating the ESLint config
		-- file (e.g., .eslintrc).
		local root_dir = config.root_dir

		if root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = root_dir,
				name = vim.fn.fnamemodify(root_dir, ":t"),
			}

			-- Support flat config
			local flat_config_files = {
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				"eslint.config.ts",
				"eslint.config.mts",
				"eslint.config.cts",
			}

			for _, file in ipairs(flat_config_files) do
				if vim.fn.filereadable(root_dir .. "/" .. file) == 1 then
					config.settings.experimental = config.settings.experimental or {}
					break
				end
			end
		end
	end,
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,

		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("[lsp] ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[lsp] Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
}
