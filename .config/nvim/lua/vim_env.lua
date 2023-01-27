-- luacheck: globals vim

-- Define variables so that even if they're undefined by a specific user, neovim
-- will know what to do with them.
vim.env.XDG_STATE_HOME =
	os.getenv("XDG_STATE_HOME") or
	os.getenv("HOME") .. '/.local/state'

vim.env.XDG_DATA_HOME =
	os.getenv("XDG_DATA_HOME") or
	os.getenv("HOME") .. '/.local/share'

vim.env.XDG_CONFIG_HOME =
	os.getenv("XDG_CONFIG_HOME") or
	os.getenv("HOME") .. '/.local/config'
