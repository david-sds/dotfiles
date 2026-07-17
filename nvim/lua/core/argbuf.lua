-- Manage Argument List
local argsdir = "~/.local/share/nvim/argsdir" -- args directory path
local argsdir_path = vim.fn.expand(argsdir)
if vim.fn.isdirectory(argsdir_path) == 0 then
	vim.fn.mkdir(argsdir_path, "p") -- Create if not exists
end
local argbuf_name = "argbuf://"

local function get_current_path()
	vim.notify("current_path " .. argsdir_path .. "/" .. vim.fn.getcwd():gsub("/", "_"))
	return argsdir_path .. "/" .. vim.fn.getcwd():gsub("/", "_")
end

local function get()
	local args = vim.fn.argv()
	if type(args) == "string" then
		args = { args }
	end
	return args
end

local function add(file)
	local args = get()
	for _, arg in ipairs(args) do
		if vim.fn.fnamemodify(arg, ":p") == file then
			return
		end
	end
	vim.cmd("argadd " .. file)
end

local function save()
	local current_path = get_current_path()
	local args = get()
	vim.fn.writefile(args, current_path)
end

local function reset()
	vim.cmd("%argdelete")
end

local function load()
	local current_path = get_current_path()
	reset()
	local lines = vim.fn.readfile(current_path)
	for _, arg in ipairs(lines) do
		add(arg)
	end
	save()
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
	callback = load,
})

local function add_current_file()
	add(vim.fn.expand("%:p"))
	save()
end

vim.api.nvim_create_autocmd("BufWriteCmd", {
	pattern = argbuf_name,
	callback = function()
		local buf = vim.fn.bufnr(argbuf_name)
		if buf == -1 then
			return
		end

		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

		reset()
		for _, line in ipairs(lines) do
			local l = line:gsub("%s+$", "")
			if l ~= "" then
				add(l)
			end
		end
		save()
		load()

		vim.bo[buf].modified = false
		local win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_close(win, true)
		vim.api.nvim_buf_delete(buf, { force = true })
	end,
})

local function open_arg_buf()
	local args = get()
	if #args == 0 then
		vim.notify("Arglist empty")
	end

	local buf = vim.fn.bufnr(argbuf_name)
	if buf == -1 then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(buf, argbuf_name)
	else
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
	end

	vim.api.nvim_create_autocmd("WinClosed", {
		buffer = buf,
		once = true,
		callback = function()
			vim.api.nvim_buf_delete(buf, { force = true })
		end,
	})

	vim.bo[buf].buftype = "acwrite"
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, args)

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
		if line == "" then
			return
		end
		vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)
		vim.cmd("e " .. line)
	end, { buffer = buf, nowait = true, silent = true })

	local width = math.floor(vim.o.columns * 0.40)
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

-- Harpoon bindings
vim.keymap.set("n", "<leader>h", add_current_file, { desc = "Add to Argument list" })
vim.keymap.set("n", "<leader>H", open_arg_buf, { desc = "Open argument edit buffer" })
for i = 1, 10 do
	local key = tostring(i % 10)
	vim.keymap.set(
		"n",
		"<leader>" .. key,
		"<CMD>argu " .. i .. "<CR>",
		{ desc = string.format("Go to argument %d", i) }
	)
end
