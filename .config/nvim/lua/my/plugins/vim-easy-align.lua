-- TODO: maybe replace with mini.align?
return {
	"junegunn/vim-easy-align",
	lazy = true,
	cmd = "EasyAlign",
	keys = {
		{
			"ga",
			"<Plug>(EasyAlign)",
			mode = { "x", "n" },
		},
	},
}
