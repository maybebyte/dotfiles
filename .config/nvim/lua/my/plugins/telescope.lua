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
			"<leader>ts",
			function()
				vim.cmd("Telescope")
			end,
			{ desc = "[T]ele[S]cope" },
		},
		{
			"<leader>sf",
			function()
				require("telescope.builtin").find_files()
			end,
			{ desc = "[S]earch [F]iles" },
		},
		{
			"<leader>gf",
			function()
				require("telescope.builtin").git_files()
			end,
			{ desc = "Search [G]it [F]iles" },
		},
		{
			"<leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			{ desc = "[S]earch [H]elp" },
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string({
					search = vim.fn.input("Grep > "),
				})
			end,
			{ desc = "[S]earch current [W]ord" },
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").live_grep()
			end,
			{ desc = "[S]earch by [G]rep" },
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			{ desc = "[S]earch [D]iagnostics" },
		},
	},
}
