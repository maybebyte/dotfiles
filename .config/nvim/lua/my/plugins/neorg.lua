return {
	"nvim-neorg/neorg",
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "v9.1.1",
	build = function()
		vim.cmd("Neorg sync-parsers")
	end,
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							neorg = "~/neorg",
						},
						default_workspace = "neorg",
					},
				},
			},
		})

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
