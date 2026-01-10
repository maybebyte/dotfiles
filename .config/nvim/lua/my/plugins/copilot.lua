return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "InsertEnter",
		config = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			server_opts_overrides = {
				settings = {
					telemetry = {
						telemetryLevel = "off",
					},
				},
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		dependencies = {
			"zbirenbaum/copilot.lua",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("copilot_cmp").setup()
			local ok, utils = pcall(require, "my.completion_utils")
			if ok then
				utils.reconfigure_cmp()
			elseif vim.env.NVIM_CMP_DEBUG then
				vim.notify("[cmp] completion_utils unavailable: " .. tostring(utils), vim.log.levels.DEBUG)
			end
		end,
	},
}
