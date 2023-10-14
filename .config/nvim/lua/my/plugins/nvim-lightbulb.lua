-- TODO: change so this lazy loads on LSP attach
return {
	"kosayoda/nvim-lightbulb",
	opts = {
		autocmd = {
			enabled = true,
		},
		-- Lightbulb should display over errors in gutter
		-- :h sign-priority
		priority = 11,
	},
	lazy = true,
	event = "VeryLazy",
}
