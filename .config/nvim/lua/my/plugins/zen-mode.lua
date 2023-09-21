return {
	"folke/zen-mode.nvim",
	lazy = true,
	cmd = "ZenMode",
	opts = {
		window = {
			backdrop = 1,
			width = 80,
			height = 0.85,
			options = {
				signcolumn = "no",
				number = false,
				relativenumber = false,
			},
		},
	},
}
