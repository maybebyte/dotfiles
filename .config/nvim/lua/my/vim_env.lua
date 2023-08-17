-- luacheck: globals vim

-- Define variables so that even if they're undefined by a specific user, neovim
-- will know what to do with them.
vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or os.getenv("HOME") .. "/.config"
vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or os.getenv("HOME") .. "/.local/share"
vim.env.XDG_STATE_HOME = vim.env.XDG_STATE_HOME or os.getenv("HOME") .. "/.local/state"
vim.env.WEBSITE_DOMAIN = vim.env.WEBSITE_DOMAIN or "www.anthes.is"
vim.env.WEBSITE_SRC_DIR = vim.env.WEBSITE_SRC_DIR or os.getenv("HOME") .. "/src/website_md"
vim.env.WEBSITE_DEST_DIR = vim.env.WEBSITE_DEST_DIR or "/var/www/htdocs/" .. vim.env.WEBSITE_DOMAIN
