local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

---@param trig string
---@param name string
---@param marker string `<` (pre-request) or `>` (post-request), escaped for fmta
local function script(trig, name, marker)
	return s(
		{ trig = trig, name = name },
		fmta(
			[[
# @lang=lua
]] .. marker .. [[ {%
<>
%}]],
			{ i(0) }
		)
	)
end

return {
	script("pre", "pre-request lua script", "<<"),
	script("<", "pre-request lua script", "<<"),
	script("post", "post-request lua script", ">>"),
	script(">", "post-request lua script", ">>"),
}
