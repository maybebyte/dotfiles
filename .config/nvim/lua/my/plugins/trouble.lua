-- luacheck: globals vim

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "Trouble" },
	keys = {
		{
			"<leader>xx",
			function()
				require("trouble").toggle("diagnostics")
			end,
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>xX",
			function()
				require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
			end,
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>xs",
			function()
				require("trouble").toggle({ mode = "symbols", focus = false })
			end,
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>xl",
			function()
				require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } })
			end,
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xL",
			function()
				require("trouble").toggle("loclist")
			end,
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			function()
				require("trouble").toggle("qflist")
			end,
			desc = "Quickfix List (Trouble)",
		},
	},
	opts = {},
}
