return {
	"tpope/vim-fugitive",
	lazy = true,
	cmd = {
		"Git",
		"Ggrep",
		"Glgrep",
		"Gclog",
		"Gllog",
		"Gcd",
		"Glcd",
		"Gedit",
		"Gsplit",
		"Gvsplit",
		"Gtabedit",
		"Gpedit",
		"Gdrop",
		"Gread",
		"Gwrite",
		"Gwq",
		"Gdiffsplit",
		"Gvdiffsplit",
		"Ghdiffsplit",
		"GMove",
		"GRename",
		"GDelete",
		"GRemove",
		"GUnlink",
	},
	cond = function()
		return vim.fn.isdirectory(".git") == 1
			or vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
	end,
}
