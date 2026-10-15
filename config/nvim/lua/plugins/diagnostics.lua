-- ============================================================================
-- TITLE : trouble.nvim
-- ABOUT : A pretty diagnostics, references, quickfix and location list viewer for Neovim.
-- ============================================================================
vim.pack.add({ "https://github.com/folke/trouble.nvim" })

vim.keymap.set("n", "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Workspace Diagnostics (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>xX",
	"<CMD>Trouble diagnostics toggle filter.buf=0<CR>",
	{ desc = "Buffer Diagnostics (Trouble)" }
)
vim.keymap.set("n", "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
vim.keymap.set(
	"n",
	"<leader>cl",
	"<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
	{ desc = "LSP Definitions / references / ... (Trouble)" }
)
vim.keymap.set("n", "<leader>xL", "<CMD>Trouble loclist toggle<CR>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<CMD>Trouble qflist toggle<CR>", { desc = "Quickfix List (Trouble)" })

require("trouble").setup({})

-- Darkens background color of trouble.nvim buffer (gruvbox-material)
local trouble_colors_group = vim.api.nvim_create_augroup("TroubleColorsGroup", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	group = trouble_colors_group,
	callback = function()
		vim.api.nvim_set_hl(0, "TroubleNormal", { link = "Normal" })
		vim.api.nvim_set_hl(0, "TroubleNormalNC", { link = "NormalNC" })
	end,
})

-- ============================================================================
-- TITLE : nvim-lint
-- ABOUT : An asynchronous linter plugin for Neovim (>= 0.9.5) complementary to the built-in Language Server Protocol support.
-- ============================================================================
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters.phpcs = {
	cmd = vim.fn.expand("~/.config/composer/vendor/bin/phpcs"),
	args = { "-q", "--standard=Moodle", "--report=json", "-" },
}
lint.linters.xmllint = function()
	-- NF-e schemas: https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=BMPFMBoln3w=
	-- Install script:
	-- > mkdir -p ~/Core/schemas/nfe
	-- > unzip -oj ~/Downloads/PL_010f*.zip -d ~/Core/schemas/nfe
	-- > printf '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.portalfiscal.inf.br/nfe" targetNamespace="http://www.portalfiscal.inf.br/nfe" elementFormDefault="qualified"><xs:include schemaLocation="leiauteNFe_v4.00.xsd"/><xs:element name="nfeProc" type="TNfeProc"/></xs:schema>' > ~/Core/schemas/nfe/procNFe_v4.00.xsd
	local nfe_schemas_types = {
		nfeProc = "procNFe_v4.00.xsd",
		NFe = "nfe_v4.00.xsd",
	}
	local args = { "--noout", "-" }
	local schema_key = table.concat(vim.api.nvim_buf_get_lines(0, 0, 5, false), "\n"):match("<(%a[%w:]*)")
	local schema_type = nfe_schemas_types[schema_key]
	if schema_type then
		args = {
			"--noout",
			"--schema",
			vim.fn.expand("~/Core/schemas/nfe/") .. schema_type,
			"-",
		}
	end
	return {
		cmd = "xmllint",
		stdin = true,
		args = args,
		stream = "stderr",
		ignore_exitcode = true,
		parser = function(output, bufnr)
			local diagnostics = require("lint.parser").from_errorformat("-:%l: %m")(output, bufnr)
			for _, d in ipairs(diagnostics) do
				local message, is_schema = d.message:gsub("^element %S+: Schemas validity error : ", "")
				if is_schema > 0 then
					d.message = message:gsub("{[^}]*}", "")
					d.source = "NF-e schema"
				end
			end
			return diagnostics
		end,
	}
end
lint.linters.mypy = require("lint.util").wrap(lint.linters.mypy, function(d)
	d.severity = vim.diagnostic.severity.WARN
	return d
end)
lint.linters.ruff.cmd = function()
	local venv = vim.fs.find(".venv", {
		upward = true,
		type = "directory",
		path = vim.fn.expand("%:p:h"),
	})[1]
	local ruff = venv and venv .. "/bin/ruff"
	return (ruff and vim.fn.executable(ruff) == 1) and ruff or "ruff"
end

lint.linters_by_ft = {
	-- php = { "phpstan" },
	php = { "phpcs" },
	xml = { "xmllint" },
	python = { "ruff", "mypy" },
}

-- Attempts to lint buffer
local try_lint_group = vim.api.nvim_create_augroup("TryLintGroup", { clear = true })
vim.api.nvim_create_autocmd({
	"BufReadPre",
	"BufNewFile",
	"BufEnter",
	"BufWritePost",
	"InsertLeave",
	"TextChanged",
}, {
	group = try_lint_group,
	callback = function()
		lint.try_lint()
	end,
})
