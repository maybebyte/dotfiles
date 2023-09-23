-- luacheck: globals vim

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
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = "mfussenegger/nvim-dap",
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
		{ "<leader>dtb" },
		{ "<leader>dtc" },
		{ "<leader>dtf" },
		-- { "<leader>dtv" },
	},
	config = function()
		require("telescope").setup()
		require("telescope").load_extension("dap")

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

		vim.keymap.set("n", "<leader>dtb", function()
			require("telescope").extensions.dap.list_breakpoints()
		end, { desc = "[D]ebug [T]elescope [B]reakpoints" })

		vim.keymap.set("n", "<leader>dtc", function()
			require("telescope").extensions.dap.commands()
		end, { desc = "[D]ebug [T]elescope [C]ommands" })

		vim.keymap.set("n", "<leader>dtf", function()
			require("telescope").extensions.dap.frames()
		end, { desc = "[D]ebug [T]elescope [F]rames" })

		-- https://github.com/nvim-telescope/telescope-dap.nvim/pull/17
		-- vim.keymap.set("n", "<leader>dtv", function()
		-- 	require("telescope").extensions.dap.variables()
		-- end, { desc = "[D]ebug [T]elescope [V]ariables" })
	end,
}
