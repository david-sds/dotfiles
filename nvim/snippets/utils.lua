local M = {}

M.copy = function(args)
	return args[1][1]
end

M.capitalize = function(args)
	local text = args[1][1] or ""
	return text:gsub("^%l", string.upper)
end

M.negate = function(args)
	local value = tonumber(args[1][1])
	if not value then
		return ""
	end
	return tostring(value * -1)
end

M.parse_date = function(input)
	if input == nil then
		return nil
	end

	local now = os.time()
	local today = os.date("*t", now)
	local year = today.year
	local month = today.month
	local text = tostring(input):lower():match("^%s*(.-)%s*$")

	local normalized = text:gsub("[%s/%-]+", "-")

	local function format_date(y, m, d)
		y = tonumber(y)
		m = tonumber(m)
		d = tonumber(d)

		if not (y and m and d) then
			return nil
		end

		if y < 100 then
			y = 2000 + y
		end

		local t = os.time({ year = y, month = m, day = d, hour = 12 })
		if not t then
			return nil
		end

		local parsed = os.date("*t", t)
		if parsed.year ~= y or parsed.month ~= m or parsed.day ~= d then
			return nil
		end

		return os.date("%Y-%m-%d", t)
	end

	-- D
	local d = normalized:match("^(%d%d?)$")
	if d then
		return format_date(year, month, d)
	end

	-- M/D
	local m2, d2 = normalized:match("^(%d%d?)%-(%d%d?)$")
	if m2 then
		return format_date(year, m2, d2)
	end

	-- Y/M/D
	local a, b, c = normalized:match("^(%d+)%-(%d%d?)%-(%d+)$")
	if a then
		return format_date(a, b, c)
	end

	-- weekday
	local weekdays = {
		sun = 0,
		mon = 1,
		tue = 2,
		wed = 3,
		thu = 4,
		fri = 5,
		sat = 6,
	}

	local target = weekdays[text:sub(1, 3)]
	if target then
		local today_wd = tonumber(os.date("%w"))
		local diff = (today_wd - target) % 7
		if diff == 0 then
			diff = 7
		end

		local t = now - diff * 86400
		return os.date("%Y-%m-%d", t)
	end

	return nil
end

M.parse_date_node = function(node)
	local parsed = M.parse_date(table.concat(node:get_text(), " "))
	if parsed then
		node:set_text({ parsed })
	end
end

return M
