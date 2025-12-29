-- luacheck: globals vim

return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{
			"<leader>st",
			function()
				require("todo-comments")
				require("telescope").extensions["todo-comments"].todo()
			end,
			desc = "[S]earch [T]odos",
		},
		{
			"<leader>xt",
			function()
				require("trouble").toggle("todo")
			end,
			desc = "Todo (Trouble)",
		},
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
