-- luacheck: globals vim

return {
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		-- See `:help gitsigns.txt`
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			vim.keymap.set(
				"n",
				"<leader>gp",
				require("gitsigns").prev_hunk,
				{ buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
			)

			vim.keymap.set(
				"n",
				"<leader>gn",
				require("gitsigns").next_hunk,
				{ buffer = bufnr, desc = "[G]o to [N]ext Hunk" }
			)

			vim.keymap.set(
				"n",
				"<leader>vh",
				require("gitsigns").preview_hunk,
				{ buffer = bufnr, desc = "[V]iew [H]unk" }
			)
		end,
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1
			or vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
	end,
}
