return {
	"hedyhli/markdown-toc.nvim",
	ft = "markdown",
	cmd = { "Mtoc" },
	opts = {
		toc_list = {
			markers = "-",
			cycle_markers = false,
		},
	},
	keys = {
		{
			"<leader>ti",
			function()
				vim.cmd("Mtoc insert")
			end,
			desc = "Insert TOC",
			ft = "markdown",
		},
		{
			"<leader>tu",
			function()
				vim.cmd("Mtoc update")
			end,
			desc = "Update TOC",
			ft = "markdown",
		},
		{
			"<leader>tr",
			function()
				vim.cmd("Mtoc remove")
			end,
			desc = "Remove TOC",
			ft = "markdown",
		},
	},
}
