return {
	"lukas-reineke/indent-blankline.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile", "FileType" },
	main = "ibl",
	opts = {
		indent = {
			char = '┊',
		},
		scope = {
			enabled = false,
		},
	},
}
