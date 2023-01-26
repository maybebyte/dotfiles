lua require('vim_env')
lua require('vim_opt')
lua require('vim_g')
lua require('keybindings')
lua require('autocmds')
lua require('plugins')

nnoremap <leader>d :r !date '+\%F'<CR>

" automatically reload configs
autocmd BufWritePost $HOME/.Xresources,$HOME/.Xdefaults !xrdb %
autocmd BufWritePost $XDG_CONFIG_HOME/ksh/kshrc !. %
autocmd BufWritePost $XDG_CONFIG_HOME/sxhkd/sxhkdrc !pkill -USR1 sxhkd

" compile lilypond files after writing
autocmd BufWritePost *.ly !lilypond %

" Enable Goyo for help files
autocmd BufReadPost /usr/local/share/nvim/runtime/doc/*,
	\$XDG_DATA_HOME/nvim/site/autoload/plugged/*/doc/* :Goyo

" one ZQ fully exits when reading help files.
" (ordinarily, one would need to ZQ twice).
autocmd BufReadPost /usr/local/share/nvim/runtime/doc/*,
	\$XDG_DATA_HOME/nvim/site/autoload/plugged/*/doc/* nnoremap ZQ :Goyo!\|q!<CR>

" shell script syntax for xsession and ksh files
autocmd BufReadPost $HOME/.xsession,$XDG_CONFIG_HOME/ksh/* set filetype=sh

" no more automatic commenting on newline
autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" if vim-plug isn't installed, install it
if empty(glob("$XDG_DATA_HOME/nvim/site/autoload/plug.vim"))
	silent !curl -fLo "$XDG_DATA_HOME/nvim/site/autoload/plug.vim" --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	autocmd VimEnter * PlugInstall --sync | source "$XDG_DATA_HOME/nvim/init.vim"
endif

" creates backup directory
if isdirectory(expand("$XDG_DATA_HOME/nvim/backup")) != 1
	silent !mkdir -p $XDG_DATA_HOME/nvim/backup
endif
