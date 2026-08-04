return {
	"nvim-neorg/neorg",
	lazy = true,
	ft = { "norg" },
	cmd = { "Neorg" },
	version = "v9.3.0",
	build = ":Neorg sync-parsers",
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
	end,
}
