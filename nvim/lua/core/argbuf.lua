-- ============================================================================
-- TITLE : argbuf
-- ABOUT : Argument management buffer
-- ============================================================================

-- Configuration
local argsdir = "~/.local/share/nvim/argsdir"
local argsdir_path = vim.fn.expand(argsdir)
if vim.fn.isdirectory(argsdir_path) == 0 then
	vim.fn.mkdir(argsdir_path, "p")
end
local argbuf_name = "argbuf://"

-- Utils
local function get_current_path()
	return argsdir_path .. "/" .. vim.fn.getcwd():gsub("/", "_")
end

local function get_args()
	local args = vim.fn.argv()
	if type(args) == "string" then
		args = { args }
	end
	return args
end

local function is_arg(file)
	local args = get_args()
	for _, arg in ipairs(args) do
		if vim.fn.fnamemodify(arg, ":p") == file then
			return true
		end
	end
	return false
end

local function add_arg(file)
	if is_arg(file) then
		return
	end
	vim.cmd("argadd " .. file)
end

local function persist()
	local current_path = get_current_path()
	local args = get_args()
	vim.fn.writefile(args, current_path)
end

local function reset_state()
	vim.cmd("%argdelete")
end

local function load()
	reset_state()
	local current_path = get_current_path()
	if vim.fn.filereadable(current_path) == 0 then
		return
	end
	local lines = vim.fn.readfile(current_path)
	for _, arg in ipairs(lines) do
		add_arg(arg)
	end
	persist()
end

-- Functions
local function add_current_file()
	add_arg(vim.fn.expand("%:p"))
	persist()
end

local function get_arg_buf()
	local buf = vim.fn.bufnr(argbuf_name)
	if buf == -1 then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, argbuf_name)
	end

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
		if line == "" then
			return
		end
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
		vim.cmd("e " .. line)
	end, { buffer = buf, nowait = true, silent = true })

	vim.keymap.set("n", "q", function()
		vim.bo[buf].modified = false
		vim.cmd("quit")
	end, { buffer = buf, nowait = true, silent = true })

	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = buf,
		once = true,
		callback = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})

	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].bufhidden = "hide"

	return buf
end

local function open_arg_buf_win()
	local buf = get_arg_buf()
	local args_state = get_args()
	local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	if not vim.deep_equal(current_lines, args_state) then
		vim.api.nvim_buf_set_lines(buf, 0, -1, true, args_state)
	end

	local width = math.floor(vim.o.columns * 0.80)
	local height = math.floor(vim.o.lines * 0.40)
	return vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
	})
end

-- Autocommands
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	callback = load,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
	pattern = argbuf_name,
	callback = function()
		local buf = vim.fn.bufnr(argbuf_name)
		if buf == -1 then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		reset_state()
		for _, line in ipairs(lines) do
			local l = line:gsub("%s+$", "")
			if l ~= "" then
				add_arg(l)
			end
		end
		persist()
		load()

		vim.bo[buf].modified = false
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
	end,
})

-- Harpoon bindings
vim.keymap.set("n", "<leader>h", add_current_file, { desc = "Add to Argument list" })
vim.keymap.set("n", "<leader>H", open_arg_buf_win, { desc = "Open argument edit buffer" })
for i = 1, 10 do
	local key = tostring(i % 10)
	vim.keymap.set(
		"n",
		"<leader>" .. key,
		"<CMD>argu " .. i .. "<CR>",
		{ desc = string.format("Go to argument %d", i) }
	)
end
