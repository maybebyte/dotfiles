-- TODO: maybe replace with Neogit or lazygit?
return {
	"tpope/vim-rhubarb",
	lazy = true,
	cond = function()
		return require("my.utils").is_git_repo()
	end,
}
