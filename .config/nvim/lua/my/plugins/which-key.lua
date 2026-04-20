-- luacheck: globals vim

return {
	"folke/which-key.nvim",
	lazy = true,
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		spec = {
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>d", group = "[D]ocument/Delete" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>v", group = "[V]iew" },
			{ "<leader>u", group = "[U]ser toggle" },
			{ "<leader>t", group = "[T]erminal/Telescope" },
		},
	},
}
