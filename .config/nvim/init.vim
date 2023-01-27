lua require('vim_env')
lua require('vim_opt')
lua require('vim_g')
lua require('keybindings')
lua require('autocmds')
lua require('plugins')

nnoremap <leader>d :r !date '+\%F'<CR>

" if vim-plug isn't installed, install it
if empty(glob("$XDG_DATA_HOME/nvim/site/autoload/plug.vim"))
	silent !curl -fLo "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	autocmd VimEnter * PlugInstall --sync | source "$XDG_DATA_HOME/nvim/init.vim"
endif

" creates backup directory
:lua <<EOF
local backup_directory = vim.env.XDG_STATE_HOME .. '/nvim/backup'

if not os.rename(backup_directory, backup_directory) then
	os.execute('mkdir -p ' .. backup_directory)
end
EOF
