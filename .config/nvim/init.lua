-- luacheck: globals vim

require('my.vim_env')
require('my.vim_opt')
require('my.vim_g')
require('my.keybindings')
require('my.autocmds')
require('my.plugins')

local backup_directory = vim.env.XDG_STATE_HOME .. '/nvim/backup'

if not os.rename(backup_directory, backup_directory) then
	os.execute('mkdir -p ' .. backup_directory)
end
