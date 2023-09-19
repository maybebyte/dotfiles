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
		{ "<leader>ts" },
		{ "<leader>sf" },
		{ "<leader>gf" },
		{ "<leader>sh" },
		{ "<leader>sw" },
		{ "<leader>sg" },
		{ "<leader>sd" },
	},
	config = function()
		vim.keymap.set("n", "<leader>ts", function()
			vim.cmd("Telescope")
		end, { desc = "[T]ele[S]cope" })

		vim.keymap.set("n", "<leader>sf", function()
			require("telescope.builtin").find_files()
		end, { desc = "[S]earch [F]iles" })

		vim.keymap.set("n", "<leader>gf", function()
			require("telescope.builtin").git_files()
		end, { desc = "Search [G]it [F]iles" })

		vim.keymap.set("n", "<leader>sh", function()
			require("telescope.builtin").help_tags()
		end, { desc = "[S]earch [H]elp" })

		vim.keymap.set("n", "<leader>sw", function()
			require("telescope.builtin").grep_string({
				search = vim.fn.input("Grep > "),
			})
		end, { desc = "[S]earch current [W]ord" })

		vim.keymap.set("n", "<leader>sg", function()
			require("telescope.builtin").live_grep()
		end, { desc = "[S]earch by [G]rep" })

		vim.keymap.set("n", "<leader>sd", function()
			require("telescope.builtin").diagnostics()
		end, { desc = "[S]earch [D]iagnostics" })
	end,
}
