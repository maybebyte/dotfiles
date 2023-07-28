return {
	'jackMort/ChatGPT.nvim',
	lazy = true,
	cmd = {
		"ChatGPT",
		"ChatGPTActAs",
		"ChatGPTCompleteCode",
		"ChatGPTEditWithInstructions",
		"ChatGPTRun",
	},
	config = function()
		require('chatgpt').setup({
			openai_params = {
				max_tokens = 1000,
			},
			api_key_cmd = "gpg --decrypt "
				.. vim.env.HOME
				.. "/passwords/api/chatgpt.txt.gpg"
		})
	end,
	dependencies = {
		'MunifTanjim/nui.nvim',
		require('my.plugins.telescope')
	},
}
