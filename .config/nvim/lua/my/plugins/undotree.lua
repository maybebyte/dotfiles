-- luacheck: globals vim

return {
	"mbbill/undotree",
	lazy = true,
	keys = {
		{ "<leader>u" },
	},
	config = function()
		vim.keymap.set("n", "<leader>u", function()
			vim.cmd.UndotreeToggle()
		end, { desc = "[U]ndo tree" })
	end,
}
