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
		return vim.fn.isdirectory(".git") == 1
			or vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null") == "true\n"
	end,
}
