-- luacheck: globals vim

require('vim_env')
require('vim_opt')
require('vim_g')
require('keybindings')
require('autocmds')
require('plugins')

local backup_directory = vim.env.XDG_STATE_HOME .. '/nvim/backup'

if not os.rename(backup_directory, backup_directory) then
	os.execute('mkdir -p ' .. backup_directory)
end
