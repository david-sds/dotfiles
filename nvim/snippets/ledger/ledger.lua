local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local events = require("luasnip.util.events")
local utils = dofile(vim.fn.stdpath("config") .. "/snippets/utils.lua")

local DATE_REGEX = "([%a%d/%-]+)"
local ENTRY_PLACEHOLDER = [[
  {} {}
      {}  {}
      {}  {}

  {}
      ]]

return {
	s(
		{
			trig = "^u" .. DATE_REGEX,
			trigEngine = "pattern",
			name = "dated entry",
			condition = function(_, _, captures)
				return captures[1] and utils.parse_date(captures[1]) ~= nil
			end,
		},
		fmt(ENTRY_PLACEHOLDER, {
			f(function(_, snip)
				return utils.parse_date(snip.captures[1])
			end),
			t("Uber"),
			t("Expenses:Transport:Uber"),
			i(1, "0"),
			t("Liabilities:CreditCard:Nubank"),
			f(utils.negate, { 1 }),
			i(2),
		})
	),
	s(
		{
			trig = "^b" .. DATE_REGEX,
			trigEngine = "pattern",
			name = "dated entry",
			condition = function(_, _, captures)
				return captures[1] and utils.parse_date(captures[1]) ~= nil
			end,
		},
		fmt(ENTRY_PLACEHOLDER, {
			f(function(_, snip)
				return utils.parse_date(snip.captures[1])
			end),
			t("Bus"),
			t("Expenses:Transport:Bus"),
			t("6.13"),
			t("Liabilities:CreditCard:Nubank"),
			t("-6.13"),
			i(1),
		})
	),
	s(
		{
			trig = "^c" .. DATE_REGEX,
			trigEngine = "pattern",
			name = "dated entry",
			condition = function(_, _, captures)
				return captures[1] and utils.parse_date(captures[1]) ~= nil
			end,
		},
		fmt(ENTRY_PLACEHOLDER, {
			f(function(_, snip)
				return utils.parse_date(snip.captures[1])
			end),
			i(1, "Description"),
			i(2, "Expenses:Food"),
			i(3, "0"),
			t("Liabilities:CreditCard:Nubank"),
			f(utils.negate, { 3 }),
			i(4),
		})
	),
	s(
		{
			trig = "^d" .. DATE_REGEX,
			trigEngine = "pattern",
			name = "dated entry",
			condition = function(_, _, captures)
				return captures[1] and utils.parse_date(captures[1]) ~= nil
			end,
		},
		fmt(ENTRY_PLACEHOLDER, {
			f(function(_, snip)
				return utils.parse_date(snip.captures[1])
			end),
			i(1, "Description"),
			i(2, "Expenses:Food"),
			i(3, "0"),
			t("Assets:Bank:Nubank"),
			f(utils.negate, { 3 }),
			i(4),
		})
	),
	s(
		DATE_REGEX,
		fmt(ENTRY_PLACEHOLDER, {
			f(function(_, snip)
				return utils.parse_date(snip.captures[1])
			end),
			i(1, "Description"),
			i(2, "Expenses:Food"),
			i(3, "0"),
			i(4, "Assets:Bank:Nubank"),
			f(utils.negate, { 3 }),
			i(5),
		})
	),
}
