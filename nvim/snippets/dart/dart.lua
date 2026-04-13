local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local function copy(args)
	return args[1][1]
end

local function capitalize(args)
	local text = args[1][1] or ""
	return text:gsub("^%l", string.upper)
end

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
				f(copy, { 1 }),
				f(copy, { 2 }),
				f(copy, { 2 }),
				f(capitalize, { 2 }),
				f(copy, { 1 }),
				f(copy, { 2 }),
			}
		)
	),
}
