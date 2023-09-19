-- luacheck: globals vim

require("my.settings")

-- Load the colorscheme before plugins due to lazy.nvim quirks.
vim.cmd("colorscheme selenized")

require("my.plugins")
require("my.keybindings")
require("my.autocmds")

local backup_directory = vim.env.XDG_STATE_HOME .. "/nvim/backup"

-- Make sure the backup directory is present and really a directory.
if os.rename(backup_directory, backup_directory) then
	if not os.rename(backup_directory, backup_directory .. "/") then
		vim.api.nvim_err_writeln(backup_directory .. " is a file, not a directory.")
		vim.opt.backup = false
	end
-- If nothing is there, attempt to create it.
else
	if not os.execute("mkdir -p " .. backup_directory) then
		vim.api.nvim_err_writeln("Failed to create " .. backup_directory)
		vim.opt.backup = false
	end
end
