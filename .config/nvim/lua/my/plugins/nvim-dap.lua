-- luacheck: globals vim

local function setup_dap_keymaps(dap)
	vim.keymap.set("n", "<leader>dc", function()
		dap.continue()
	end, { desc = "[D]ebug [C]ontinue" })

	vim.keymap.set("n", "<leader>do", function()
		dap.step_over()
	end, { desc = "[D]ebug Step [O]ver" })

	vim.keymap.set("n", "<leader>dO", function()
		dap.step_out()
	end, { desc = "[D]ebug Step [O]ut" })

	vim.keymap.set("n", "<leader>di", function()
		dap.step_into()
	end, { desc = "[D]ebug Step [I]nto" })

	vim.keymap.set("n", "<leader>db", function()
		dap.toggle_breakpoint()
	end, { desc = "[D]ebug Toggle [B]reakpoint" })

	vim.keymap.set("n", "<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "[D]ebug [B]reakpoint Condition" })

	vim.keymap.set("n", "<leader>dC", function()
		dap.run_to_cursor()
	end, { desc = "[D]ebug Run to [C]ursor" })

	vim.keymap.set("n", "<leader>dj", function()
		dap.down()
	end, { desc = "[D]ebug Down (j)" })

	vim.keymap.set("n", "<leader>dk", function()
		dap.up()
	end, { desc = "[D]ebug Down (k)" })

	vim.keymap.set("n", "<leader>dT", function()
		dap.terminate()
	end, { desc = "[D]ebug [T]erminate" })
end

return {
	"mfussenegger/nvim-dap",
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	tag = "0.6.0",
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
	config = function()
		local dap = require("dap")
		setup_dap_keymaps(dap)
	end,
}
