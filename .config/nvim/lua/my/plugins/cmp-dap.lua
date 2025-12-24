-- Completion source for DAP buffers
-- Loads only when entering DAP-related filetypes
return {
	"rcarriga/cmp-dap",
	ft = { "dap-repl", "dapui_watches", "dapui_hover" },
	dependencies = {
		"hrsh7th/nvim-cmp",
		"mfussenegger/nvim-dap",
	},
	config = function()
		require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
			sources = {
				{ name = "dap" },
			},
		})
	end,
}
