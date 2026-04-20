-- luacheck: globals vim Snacks

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		terminal = { enabled = true },
	},
	keys = {
		{
			"<leader>tt",
			function()
				Snacks.terminal.toggle(nil, { cwd = require("my.root").get() })
			end,
			desc = "[T]erminal (project root)",
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		-- UTILS-04: spell toggle migrated from inline keybindings/init.lua block.
		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>o")
	end,
}
