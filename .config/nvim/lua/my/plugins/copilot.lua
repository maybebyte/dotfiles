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
			else
				vim.notify("[cmp] Failed to load completion_utils: " .. tostring(utils), vim.log.levels.WARN)
			end
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		lazy = true,
		dependencies = { "zbirenbaum/copilot.lua", "nvim-lua/plenary.nvim", branch = "master" },
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatStop",
			"CopilotChatReset",
			"CopilotChatSave",
			"CopilotChatLoad",
			"CopilotChatPrompts",
			"CopilotChatModels",
			"CopilotChatAgents",
			"CopilotChatCommit",
			"CopilotChatDocs",
			"CopilotChatExplain",
			"CopilotChatFix",
			"CopilotChatOptimize",
			"CopilotChatReview",
			"CopilotChatTests",
		},
		opts = {
			model = "claude-sonnet-4",
			agent = "copilot",
		},
		config = function(_, opts)
			vim.opt.completeopt = vim.opt.completeopt
				+ {
					-- For Neovim < 0.11.0, from README
					noinsert = true,
					noselect = true,

					-- For Neovim, even if >= 0.11.0, from README
					popup = true,
				}

			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("CopilotChatBufSettings", { clear = true }),
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
					vim.opt_local.conceallevel = 0
				end,
			})

			require("CopilotChat").setup(opts)
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		lazy = true,
		cmd = {
			"CodeCompanion",
			"CodeCompanionCmd",
			"CodeCompanionChat",
			"CodeCompanionActions",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local codecompanion = require("codecompanion")
			codecompanion.setup({
				adapters = {
					copilot_local = function()
						return require("codecompanion.adapters").extend("copilot", {
							name = "copilot_local",
							schema = {
								model = {
									default = "claude-sonnet-4",
								},
							},
						})
					end,
				},
				strategies = {
					chat = {
						adapter = "copilot_local",
					},
					inline = {
						adapter = "copilot_local",
					},
					cmd = {
						adapter = "copilot_local",
					},
				},
			})
		end,
	},
}
