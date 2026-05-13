local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local events = require("luasnip.util.events")
local utils = dofile(vim.fn.stdpath("config") .. "/snippets/utils.lua")

return {
	s(
		"e",
		fmt(
			[[
{} {}
    {}  {}
    {}  {}

{}
    ]],
			{
				i(1, os.date("%Y-%m-%d"), {
					node_callbacks = {
						[events.leave] = utils.parse_date_node,
					},
				}),
				i(2, "Description"),
				i(3, "Expenses:Food"),
				i(4, "0"),
				i(5, "Assets:Bank:Nubank"),
				f(utils.negate, { 4 }),
				i(6),
			}
		)
	),
}
