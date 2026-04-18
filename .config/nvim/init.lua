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

-- CONFIG-05: defensively suppress clipboard provider probe during startup.
-- If my.settings (or any future module pre-VeryLazy) sets vim.opt.clipboard,
-- save its value and clear it; the VeryLazy callback restores it.
local saved_clipboard = vim.opt.clipboard:get()
vim.opt.clipboard = ""

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

	local hl_overrides_group = vim.api.nvim_create_augroup("my_highlight_overrides", { clear = true })
	local overrides = {
		Normal  = { bg = "NONE", ctermbg = "NONE" },
		NonText = { bg = "NONE", ctermbg = "NONE" },
	}
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = hl_overrides_group,
		callback = function()
			for name, opts in pairs(overrides) do
				vim.api.nvim_set_hl(0, name, opts)
			end
		end,
		desc = "Apply transparent-bg overrides across colorscheme changes",
	})
	-- D-09: ColorScheme does not retro-fire at registration; invoke once manually
	-- so the already-active catppuccin-frappe picks up the overrides without flash.
	vim.api.nvim_exec_autocmds("ColorScheme", { group = hl_overrides_group })

	require("lazy").setup("my.plugins")
end

require("my.autocmds")

-- CONFIG-01 + CONFIG-05: defer non-essential init to after lazy.nvim fires VeryLazy.
-- VeryLazy runs after LazyDone + VimEnter in interactive mode. In headless mode
-- it does not auto-fire; tests must invoke it explicitly with `doautocmd User VeryLazy`.
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		require("my.keybindings")
		if saved_clipboard and #saved_clipboard > 0 then
			vim.opt.clipboard = saved_clipboard
		end
	end,
	desc = "Post-startup deferred init (keymaps, clipboard restore)",
})
