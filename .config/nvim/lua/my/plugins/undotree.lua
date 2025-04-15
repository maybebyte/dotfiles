-- luacheck: globals vim

return {
	"jiaoshijie/undotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	lazy = true,
	keys = {
		{ "<leader>u", desc = "[U]ndo tree" },
	},
	config = function()
		require("undotree").setup({
			window = {
				winblend = 0, -- disable transparency since doubled text messes with my eyes
			},
		})
		vim.keymap.set("n", "<leader>u", require("undotree").toggle, { desc = "[U]ndo tree" })
	end,
}
