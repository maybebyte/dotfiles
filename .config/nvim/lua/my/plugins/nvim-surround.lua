return {
	"kylechui/nvim-surround",
	version = "*",
	lazy = true,
	keys = {
		-- Normal mode operations
		{ "ys", desc = "Add surround", mode = "n" },
		{ "yss", desc = "Add surround to line", mode = "n" },
		{ "yS", desc = "Add surround with motion on new lines", mode = "n" },
		{ "ySS", desc = "Add surround to line on new lines", mode = "n" },
		{ "ds", desc = "Delete surround", mode = "n" },
		{ "cs", desc = "Change surround", mode = "n" },
		{ "cS", desc = "Change surround on new lines", mode = "n" },

		-- Visual mode operations
		{ "S", desc = "Surround selection", mode = "v" },
		{ "gS", desc = "Surround selection on new lines", mode = "v" },

		-- Insert mode operations
		{ "<C-g>s", desc = "Add surround in insert mode", mode = "i" },
		{ "<C-g>S", desc = "Add surround on new lines in insert mode", mode = "i" },
	},
	opts = {},
}
