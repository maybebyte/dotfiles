return {
	"stevearc/oil.nvim",
	lazy = true,
	cmd = { "Oil" },
	keys = {
		{ "-", desc = "Open parent directory" },
	},
	opts = {
		columns = { "icon" },
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
			["<M-h>"] = "actions.select_split",
			["<M-l>"] = "actions.refresh",
		},
		view_options = {
			show_hidden = true,
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)

		vim.keymap.set("n", "-", function()
			require("oil").open()
		end, { desc = "Open parent directory" })
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
