-- TODO: maybe replace with Neogit or lazygit?
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
		return require("my.utils").is_git_repo()
	end,
}
