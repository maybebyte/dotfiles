-- luacheck: globals vim

return {
	"junegunn/goyo.vim",
	lazy = true,
	ft = "help",
	cmd = "Goyo",
	keys = {
		{
			"<leader>gy",
			function()
				-- Preserve previous background rather than neovim's global
				-- default of "dark"
				-- https://github.com/junegunn/goyo.vim/issues/78
				local previous_background = vim.o.background
				vim.cmd("Goyo")
				vim.opt.background = previous_background
			end,
			{ desc = "Toggle [g]o[y]o" },
		},
	},
}
