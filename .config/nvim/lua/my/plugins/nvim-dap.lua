-- TODO: Update plugins?

return {
	"mfussenegger/nvim-dap",
	lazy = true,
	tag = "0.6.0",
	keys = {
		{ "<leader>dc", function() require("dap").continue() end, desc = "[D]ebug [C]ontinue" },
		{ "<leader>do", function() require("dap").step_over() end, desc = "[D]ebug Step [O]ver" },
		{ "<leader>dO", function() require("dap").step_out() end, desc = "[D]ebug Step [O]ut" },
		{ "<leader>di", function() require("dap").step_into() end, desc = "[D]ebug Step [I]nto" },
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "[D]ebug Toggle [B]reakpoint" },
		{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "[D]ebug [B]reakpoint Condition" },
		{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "[D]ebug Run to [C]ursor" },
		{ "<leader>dj", function() require("dap").down() end, desc = "[D]ebug Down (j)" },
		{ "<leader>dk", function() require("dap").up() end, desc = "[D]ebug Up (k)" },
		{ "<leader>dT", function() require("dap").terminate() end, desc = "[D]ebug [T]erminate" },
	},
	dependencies = {
		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
		-- mason.nvim integration
		{
			"jay-babu/mason-nvim-dap.nvim",
			tag = "v2.1.1",
			dependencies = { "williamboman/mason.nvim", opts = {} },
			opts = {
				ensure_installed = {
					"python",
				},
				handlers = {},
			},
		},
		-- fancy UI for the debugger
		{
			"rcarriga/nvim-dap-ui",
			tag = "v3.9.1",
			keys = {
				{
					"<leader>du",
					function()
						require("dapui").toggle({})
					end,
					desc = "Dap UI",
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					desc = "Eval",
					mode = { "n", "v" },
				},
			},
			opts = {},
			config = function(_, opts)
				local dap = require("dap")
				local dapui = require("dapui")
				dapui.setup(opts)

				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open({})
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close({})
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close({})
				end
			end,
		},
	},
}
