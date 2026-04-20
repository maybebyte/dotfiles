-- TODO: maybe replace with Neogit or lazygit?
return {
	"tpope/vim-rhubarb",
	lazy = true,
	dependencies = {
		"tpope/vim-fugitive",
	},
	cmd = {
		"GBrowse",
	},
	cond = function()
		return require("my.utils").is_git_repo()
	end,
}
