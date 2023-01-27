-- luacheck: globals vim

-- Define variables so that even if they're undefined by a specific user, neovim
-- will know what to do with them.
vim.env.XDG_CONFIG_HOME =
	vim.env.XDG_CONFIG_HOME or
	os.getenv('HOME') .. '/.local/config'

vim.env.XDG_DATA_HOME =
	vim.env.XDG_DATA_HOME or
	os.getenv('HOME') .. '/.local/share'

vim.env.XDG_STATE_HOME =
	vim.env.XDG_STATE_HOME or
	os.getenv('HOME') .. '/.local/state'
