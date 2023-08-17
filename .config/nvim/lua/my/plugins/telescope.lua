return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	tag = "0.1.2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = function()
				vim.cmd("!gmake")
			end,
		},
	},
	keys = {
		{
			"<leader>tsc",
			function()
				vim.cmd("Telescope")
			end,
		},
		{
			"<leader>tsff",
			function()
				require("telescope.builtin").find_files()
			end,
		},
		{
			"<leader>tsgf",
			function()
				require("telescope.builtin").git_files()
			end,
		},
		{
			"<leader>tsgr",
			function()
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
				})
			end,
		},
	},
}
