-- luacheck: globals vim

return {
	"jackMort/ChatGPT.nvim",
	lazy = true,
	cmd = {
		"ChatGPT",
		"ChatGPTActAs",
		"ChatGPTEditWithInstructions",
		"ChatGPTRun",
	},
	keys = {
		{ "<leader>aic" },
		{ "<leader>aie" },
		{ "<leader>air" },
		{ "<leader>aia" },
		{ "<leader>aig" },
	},
	opts = {
		openai_params = {
			model = "gpt-4",
			max_tokens = 1000,
		},
		api_key_cmd = "gpg --decrypt " .. vim.env.HOME .. "/passwords/api/chatgpt.txt.gpg",
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		require("my.plugins.telescope"),
	},
	config = function(_, opts)
		vim.keymap.set("n", "<leader>aic", function()
			vim.cmd.ChatGPTCompleteCode()
		end, { desc = "[AI] [C]omplete" })
		vim.keymap.set("n", "<leader>aie", function()
			vim.cmd.ChatGPTEditWithInstructions()
		end, { desc = "[AI] [E]dit" })
		vim.keymap.set("n", "<leader>air", function()
			vim.cmd.ChatGPTRun()
		end, { desc = "[AI] [R]un" })
		vim.keymap.set("n", "<leader>aia", function()
			vim.cmd.ChatGPTActAs()
		end, { desc = "[AI] [A]ct as" })
		vim.keymap.set("n", "<leader>aig", function()
			vim.cmd.ChatGPT()
		end, { desc = "[AI] [G]eneric" })
		require("chatgpt").setup(opts)
	end,
}
