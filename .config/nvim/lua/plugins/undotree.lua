-- ================================================================================================
-- TITLE : undotree
-- ABOUT : Undotree visualizes the undo history and makes it easy to browse and switch between different undo branches.
-- LINKS :
--   > github : https://github.com/mbbill/undotree
-- ================================================================================================

return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
	},
}
