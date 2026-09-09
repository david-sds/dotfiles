-- ============================================================================
-- TITLE : omarchy
-- ABOUT : Follow the active Omarchy colorscheme using vim.pack (no lazy.nvim).
--         Installs every theme plugin Omarchy can stage, resolves the current
--         theme from Omarchy's state, applies it, and live hot-reloads whenever
--         Omarchy swaps themes. This file is ONLY relevant on Omarchy systems;
--         it falls back to gruvbox-material when Omarchy is absent.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. Install every colorscheme plugin Omarchy can stage, plus our fallback.
-- ---------------------------------------------------------------------------
vim.pack.add({
	"https://github.com/tahayvr/matteblack.nvim",
	"https://github.com/folke/tokyonight.nvim",
	"https://github.com/catppuccin/nvim",
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/neanias/everforest-nvim",
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/kepano/flexoki-neovim",
	"https://github.com/EdenEast/nightfox.nvim",
	"https://github.com/ribru17/bamboo.nvim",
	"https://github.com/rose-pine/neovim",
	"https://github.com/ficcdaf/ashen.nvim",
	"https://github.com/bjarneo/aether.nvim",
	"https://github.com/bjarneo/hackerman.nvim",
	"https://github.com/bjarneo/vantablack.nvim",
	"https://github.com/bjarneo/white.nvim",
	"https://github.com/bjarneo/ethereal.nvim",
	"https://github.com/omacom-io/lumon.nvim",
	"https://github.com/OldJobobo/retro-82.nvim",
	"https://github.com/OldJobobo/miasma.nvim",
	"https://github.com/gthelding/monokai-pro.nvim",
	"https://github.com/sainnhe/gruvbox-material",
})

-- ---------------------------------------------------------------------------
-- 2. Resolve / apply the active Omarchy theme.
-- ---------------------------------------------------------------------------

-- gruvbox-material is our fallback colorscheme.
vim.g.gruvbox_material_background = "hard" -- hard, medium, soft
vim.g.gruvbox_material_foreground = "original" -- material, mix, original

local THEME_FILE = vim.fn.expand("$HOME/.local/state/omarchy/current/theme/neovim.lua")
local FALLBACK = "gruvbox-material"

-- Set plugin-level options before sourcing the colorscheme, mirroring what each
-- colorscheme reads from vim.g.<name> per the staged Omarchy spec.
local function apply_theme_opts(opts)
	if not opts then
		return
	end

	-- catppuccin: flavour (latte/mocha/...)
	if opts.flavour then
		vim.g.catppuccin_flavour = opts.flavour
	end

	-- everforest: background (soft/medium/hard)
	if opts.background then
		vim.g.everforest_background = opts.background
	end

	-- gruvbox (ellisonleao): style
	if opts.style then
		vim.g.gruvbox_style = opts.style
	end
end

-- Read and parse the Omarchy-staged neovim.lua spec.
-- Returns { colorscheme = <string>, plugin = <string|nil>, opts = <table> }.
local function resolve()
	local fallback = { colorscheme = FALLBACK, plugin = nil, opts = {} }

	if vim.fn.filereadable(THEME_FILE) ~= 1 then
		return fallback
	end

	local f = loadfile(THEME_FILE)
	if not f then
		return fallback
	end

	local ok, spec = pcall(f)
	if not ok or type(spec) ~= "table" then
		return fallback
	end

	local result = { colorscheme = nil, plugin = nil, opts = {} }

	for _, entry in ipairs(spec) do
		if type(entry) == "table" then
			local repo = entry[1]
			local opts = entry.opts or {}

			if repo and repo ~= "LazyVim/LazyVim" then
				if not result.plugin then
					result.plugin = repo
				end
				for k, v in pairs(opts) do
					result.opts[k] = v
				end
			else
				if opts.colorscheme then
					result.colorscheme = opts.colorscheme
				end
				for k, v in pairs(opts) do
					if k ~= "colorscheme" then
						result.opts[k] = v
					end
				end
			end
		end
	end

	if not result.colorscheme then
		return fallback
	end

	return result
end

local float_hl_group

-- Green visual highlight on all floating windows (persists across reloads).
local function setup_float_highlight()
	if float_hl_group then
		vim.api.nvim_del_augroup_by_id(float_hl_group)
	end

	float_hl_group = vim.api.nvim_create_augroup("FloatVisualHighlight", { clear = true })
	vim.api.nvim_create_autocmd("WinNew", {
		group = float_hl_group,
		callback = function()
			local win = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_config(win).relative ~= "" then
				vim.wo[win].winhighlight = "Visual:Search"
			end
		end,
	})
end

-- Apply the resolved theme (or fallback), resetting for light themes.
local function apply()
	local spec = resolve()
	apply_theme_opts(spec.opts)

	-- Reset so light themes can set background themselves.
	vim.o.background = "dark"
	vim.cmd("highlight clear")

	local applied = pcall(vim.cmd.colorscheme, spec.colorscheme)
	if not applied then
		vim.cmd.colorscheme(FALLBACK)
	end

	vim.cmd("redraw!")
	vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
	vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

	-- Use terminal background: normal text and signcolumn become transparent.
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
	-- for _, name in ipairs({
	-- 	"GitSignsAdd",
	-- 	"GitSignsChange",
	-- 	"GitSignsDelete",
	-- 	"GitSignsAddLnr",
	-- 	"GitSignsChangeLnr",
	-- 	"GitSignsDeleteLnr",
	-- }) do
	-- 	local fg = vim.api.nvim_get_hl_by_id(vim.api.nvim_get_hl_id_by_name(name), true).foreground
	-- 	local attrs = { bg = "none" }
	-- 	if fg then
	-- 		attrs.fg = string.format("#%06x", fg)
	-- 	end
	-- 	vim.api.nvim_set_hl(0, name, attrs)
	-- end

	setup_float_highlight()
end

-- ---------------------------------------------------------------------------
-- 3. Apply now and live hot-reload on theme changes.
-- ---------------------------------------------------------------------------
apply()

local last_mtime = vim.fn.getftime(THEME_FILE)

vim.fn.timer_start(1000, function()
	local now = vim.fn.getftime(THEME_FILE)
	if now ~= last_mtime then
		last_mtime = now
		vim.schedule(apply)
	end
end, { ["repeat"] = -1 })
