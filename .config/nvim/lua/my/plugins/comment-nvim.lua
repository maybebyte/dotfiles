return {
	"numToStr/Comment.nvim",
	lazy = true,
	keys = {
		{ "gcc", mode = "n", desc = "Toggle comment (line)" },
		{ "gbc", mode = "n", desc = "Toggle comment (block)" },
		{ "gc", mode = { "n", "o" }, desc = "Toggle comment (motion)" },
		{ "gb", mode = { "n", "o" }, desc = "Toggle block comment (motion)" },
		{ "gc", mode = "x", desc = "Toggle comment (visual)" },
		{ "gb", mode = "x", desc = "Toggle block comment (visual)" },
		{ "gco", mode = "n", desc = "Insert comment below" },
		{ "gcO", mode = "n", desc = "Insert comment above" },
		{ "gcA", mode = "n", desc = "Insert comment at end of line" },
	},
	opts = {},
}
