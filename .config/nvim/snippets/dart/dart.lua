local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep

return {
	-- s("stl", {
	-- 	t("class "),
	-- 	i(1, "MyWidget"),
	-- 	t(" extends StatelessWidget {"),
	-- 	t({ "", "  const " }),
	-- 	rep(1), -- mirror of i(1)
	-- 	t({ "({super.key});", "", "" }),
	-- 	t("  @override"),
	-- 	t({ "", "  Widget build(BuildContext context) {", "    return " }),
	-- 	i(0, "Placeholder"),
	-- 	t({ "();", "  }", "}" }),
	-- }),
	s("printLUA", {
		t("print("),
		c(1, { t('"hello"'), t('"world"'), t("variable") }),
		t(")"),
	}),
}
