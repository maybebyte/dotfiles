lua require('vim_env')
lua require('vim_opt')
lua require('vim_g')
lua require('keybindings')
lua require('autocmds')
lua require('plugins')

nnoremap <leader>d :r !date '+\%F'<CR>

" creates backup directory
:lua <<EOF
local backup_directory = vim.env.XDG_STATE_HOME .. '/nvim/backup'

if not os.rename(backup_directory, backup_directory) then
	os.execute('mkdir -p ' .. backup_directory)
end
EOF
