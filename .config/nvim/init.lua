if vim.g.my_config_loaded then
	return
end
vim.g.my_config_loaded = true

local function bootstrap_plugin_manager()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	-- Attempt to clone with a timeout to prevent blocking indefinitely
	if not vim.uv.fs_stat(lazypath) then
		vim.fn.system({
			"timeout",
			"10s",
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable",
			lazypath,
		})

		-- Check if the clone was successful
		if vim.v.shell_error ~= 0 then
			vim.notify(
				"Failed to install lazy.nvim (network issue or timeout). Starting without plugins.",
				vim.log.levels.WARN
			)
			return false
		end
	end
	vim.opt.rtp:prepend(lazypath)
	return true
end

local function setup_backup_directory()
	local backup_directory = vim.env.XDG_STATE_HOME .. "/nvim/backup"
	local ok, err = pcall(vim.fn.mkdir, backup_directory, "p")
	if not ok then
		vim.notify(
			"Failed to create " .. backup_directory .. ": " .. tostring(err),
			vim.log.levels.WARN
		)
		vim.opt.backup = false
	end
end

require("my.settings")

local lazy_ready = bootstrap_plugin_manager()
setup_backup_directory()

if lazy_ready then
	-- Load colorscheme before lazy.setup() so it's available during plugin installation UI
	local catppuccin_path = vim.fn.stdpath("data") .. "/lazy/catppuccin"
	if vim.uv.fs_stat(catppuccin_path) then
		vim.opt.rtp:prepend(catppuccin_path)
		pcall(function()
			vim.cmd("colorscheme catppuccin-frappe")
		end)
	end

	require("lazy").setup("my.plugins")
end

vim.cmd("highlight Normal guibg=none")
vim.cmd("highlight NonText guibg=none")
vim.cmd("highlight Normal ctermbg=none")
vim.cmd("highlight NonText ctermbg=none")

require("my.keybindings")
require("my.autocmds")
