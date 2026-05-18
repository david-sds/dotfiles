local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local events = require("luasnip.util.events")
local utils = dofile(vim.fn.stdpath("config") .. "/snippets/utils.lua")

return {
	s(
		{
			trig = "^([%a%d/%-]+)",
			trigEngine = "pattern",
			name = "dated entry",
			condition = function(_, _, captures)
				return captures[1] and utils.parse_date(captures[1]) ~= nil
			end,
		},
		fmt(
			[[
  {} {}
      {}  {}
      {}  {}

  {}
      ]],
			{
				f(function(_, snip)
					return utils.parse_date(snip.captures[1])
				end),
				i(1, "Description"),
				i(2, "Expenses:Food"),
				i(3, "0"),
				i(4, "Assets:Bank:Nubank"),
				f(utils.negate, { 3 }),
				i(5),
			}
		)
	),
	s(
		"entry",
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
