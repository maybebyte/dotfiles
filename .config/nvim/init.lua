-- luacheck: globals vim

require('my.vim_env')
require('my.vim_opt')
require('my.vim_g')
require('my.vim_b')
require('my.plugins')
require('my.coc')
require('my.keybindings')
require('my.autocmds')

vim.cmd('colorscheme selenized')

local backup_directory = vim.env.XDG_STATE_HOME .. '/nvim/backup'

-- Make sure the backup directory is present and really a directory.
if os.rename(backup_directory, backup_directory) then
	if not os.rename(backup_directory, backup_directory .. '/') then
		vim.api.nvim_err_writeln(
			backup_directory .. ' is a file, not a directory.'
		)
		vim.opt.backup = false
	end
-- If nothing is there, attempt to create it.
else
	if not os.execute('mkdir -p ' .. backup_directory) then
		vim.api.nvim_err_writeln('Failed to create ' .. backup_directory)
		vim.opt.backup = false
	end
end
