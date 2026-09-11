local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local utils = require("utils.snippets")

local DATE_REGEX_BASE = "([%a%d/%-]+)"
local function get_date_regex(prefix)
	prefix = prefix or ""
	return "^" .. prefix .. DATE_REGEX_BASE
end

local ENTRY_PLACEHOLDER = [[
  {} {}
      {}  {}
      {}  {}

  {}
      ]]

return {
	s(
		{
			trig = get_date_regex(),
			trigEngine = "pattern",
			name = "today entry",
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
			i(4, "Assets:Bank:Nubank"),
			f(utils.negate, { 3 }),
			i(5),
		})
	),
	s(
		{
			trig = get_date_regex("u"),
			trigEngine = "pattern",
			name = "uber entry",
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
			trig = get_date_regex("b"),
			trigEngine = "pattern",
			name = "bus entry",
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
			trig = get_date_regex("c"),
			trigEngine = "pattern",
			name = "credit card entry",
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
			trig = get_date_regex("d"),
			trigEngine = "pattern",
			name = "debit card entry",
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
}
