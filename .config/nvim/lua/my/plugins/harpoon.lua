return {
	"ThePrimeagen/harpoon",
	lazy = true,
	keys = {
		{
			"<leader>haf",
			function()
				require("harpoon.mark").add_file()
			end,
			{ desc = "[H]arpoon [a]dd [f]ile" },
		},
		{
			"<leader>hqm",
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			{ desc = "[H]arpoon [q]uick [m]enu" },
		},
		{
			"<leader>h1",
			function()
				require("harpoon.ui").nav_file(1)
			end,
			{ desc = "[H]arpoon file [1]" },
		},
		{
			"<leader>h2",
			function()
				require("harpoon.ui").nav_file(2)
			end,
			{ desc = "[H]arpoon file [2]" },
		},
		{
			"<leader>h3",
			function()
				require("harpoon.ui").nav_file(3)
			end,
			{ desc = "[H]arpoon file [3]" },
		},
		{
			"<leader>h4",
			function()
				require("harpoon.ui").nav_file(4)
			end,
			{ desc = "[H]arpoon file [4]" },
		},
		{
			"<leader>hn",
			function()
				require("harpoon.ui").nav_next()
			end,
			{ desc = "[H]arpoon [n]ext" },
		},
		{
			"<leader>hp",
			function()
				require("harpoon.ui").nav_prev()
			end,
			{ desc = "[H]arpoon [p]revious" },
		},
	},
}
