-- luacheck: globals vim

return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "[S]earch [T]odos" },
		{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
	},
	opts = {},
}
