local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local utils = dofile(vim.fn.stdpath("config") .. "/snippets/utils.lua")

return {
	s(
		"obx",
		fmt(
			[[
  @observable
  {} _{} = {};
  @computed
  {} get {} => _{};
  @action
  void set{}({} value) => _{} = value;
  ]],
			{
				i(1),
				i(2),
				i(3),
				f(utils.copy, { 1 }),
				f(utils.copy, { 2 }),
				f(utils.copy, { 2 }),
				f(utils.capitalize, { 2 }),
				f(utils.copy, { 1 }),
				f(utils.copy, { 2 }),
			}
		)
	),
}
