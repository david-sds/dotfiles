local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function negate(args)
	local value = tonumber(args[1][1])
	if not value then
		return ""
	end
	return tostring(value * -1)
end

return {
	s(
		"et",
		fmt(
			[[
{} {}
    {}  {}
    {}  {}

{}
    ]],
			{
				i(1, os.date("%Y-%m-%d")),
				i(2, "Description"),
				i(3, "Expenses:Food"),
				i(4, "0"),
				i(5, "Assets:Bank:Nubank"),
				f(negate, { 4 }),
				i(6),
			}
		)
	),
}
