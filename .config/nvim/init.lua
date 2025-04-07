-- luacheck: globals vim

-- TODO: maybe add CopilotChat.nvim?
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim

local function bootstrap_plugin_manager()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
end

local function setup_backup_directory()
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
end

require("my.settings")

bootstrap_plugin_manager()
setup_backup_directory()

require("lazy").setup("my.plugins")

vim.cmd("colorscheme catppuccin-frappe")

-- Set transparency (must come after colorscheme)
vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")

require("my.keybindings")
require("my.autocmds")
