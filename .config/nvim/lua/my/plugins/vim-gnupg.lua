return {
	"jamessan/vim-gnupg",
	-- NOTE: Plugin uses BufReadCmd/BufWriteCmd which requires eager loading
	-- to intercept file operations before Neovim processes them.
	-- GPG settings (GPGExecutable, GPGDefaultRecipients, etc.) are configured
	-- in lua/my/settings/vim_g.lua
	lazy = false,
}
