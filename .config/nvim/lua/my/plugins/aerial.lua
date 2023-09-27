-- luacheck: globals vim

return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- Optional
	},
	lazy = true,
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>an" },
		{ "<leader>ap" },
		{ "<leader>at" },
	},
	config = function()
		require("aerial").setup({
			on_attach = function(bufnr)
				vim.keymap.set("n", "<leader>an", function()
					vim.cmd("AerialNext")
				end, { buffer = bufnr, desc = "[A]erial [N]ext" })
				vim.keymap.set("n", "<leader>ap", function()
					vim.cmd("AerialPrev")
				end, { buffer = bufnr, desc = "[A]erial [P]revious" })
			end,
		})
		vim.keymap.set("n", "<leader>at", function()
			vim.cmd("AerialToggle!")
		end, { desc = "[A]erial [T]oggle" })
	end,
}
