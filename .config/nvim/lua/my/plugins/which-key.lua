-- luacheck: globals vim

return {
	"folke/which-key.nvim",
	lazy = true,
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {},
}
