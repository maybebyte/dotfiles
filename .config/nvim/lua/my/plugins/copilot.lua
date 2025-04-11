return {
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "InsertEnter",
		config = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
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
		opts = {},
		config = function(_, opts)
			vim.opt.completeopt = vim.opt.completeopt + {
				-- For Neovim < 0.11.0, from README
				noinsert = true,
				noselect = true,

				-- For Neovim, even if >= 0.11.0, from README
				popup = true
			}

			require("CopilotChat").setup(opts)
		end,
	},
}
