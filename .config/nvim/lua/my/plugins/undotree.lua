return {
	"mbbill/undotree",
	lazy = true,
	keys = {
		{
			"<leader>u",
			function()
				vim.cmd.UndotreeToggle()
			end,
		},
	},
}
