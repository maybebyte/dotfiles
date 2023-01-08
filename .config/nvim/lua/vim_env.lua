-- Define variables so that even if they're undefined by a specific user, neovim
-- will know what to do with them.
vim.env.XDG_STATE_HOME = os.getenv("HOME") .. '/.local/state'
