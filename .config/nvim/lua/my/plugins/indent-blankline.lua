return {
	"lukas-reineke/indent-blankline.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		char = '┊',
		show_trailing_blankline_indent = false,
	},
}
