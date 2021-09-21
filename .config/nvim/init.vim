set autochdir
set backup
set backupdir     =$HOME/.local/share/nvim/backup
set conceallevel  =2
set diffexpr      =
set diffopt      +=iwhiteall
set expandtab
set ignorecase
set laststatus    =0
set lazyredraw
set linebreak
" https://security.stackexchange.com/questions/36001/vim-modeline-vulnerabilities
set modelines     =0
set nomodeline
set number
set relativenumber
set shiftwidth    =2
set smartcase
set smartindent
set splitbelow
set splitright
set tabstop       =2
set textwidth     =72
set undofile
set wrap
set wrapscan

" copy and paste to CLIPBOARD selection
vnoremap <C-c> "+y
nnoremap <C-p> "+P

" to protecc my left pinky finger
noremap ; :
noremap : ;

" plugin bindings
let mapleader=","

nnoremap <leader>n :NERDTreeToggle
nnoremap <leader>f :FZF $HOME
nnoremap <leader>g :Goyo
nnoremap <leader>d :r !date '+\%F'

" spell-check set to <leader>o, 'o' for 'orthography':
nnoremap <leader>o :set spell! spelllang=en_us

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" automatically deletes all trailing whitespace and newlines at end of
" file on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" automatically reload configs
autocmd BufWritePost $HOME/.Xresources,$HOME/.Xdefaults !xrdb %
autocmd BufWritePost $HOME/.config/ksh/kshrc !. %
autocmd BufWritePost $HOME/.config/sxhkd/sxhkdrc !pkill -USR1 sxhkd

" Enable Goyo by default for mutt writing
" Is buggy in Neomutt, nomodifiable bug
"autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo
"autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=72
"autocmd BufRead,BufNewFile /tmp/neomutt* noremap ZZ :Goyo!\|x!
"autocmd BufRead,BufNewFile /tmp/neomutt* noremap ZQ :Goyo!\|q!

" Enable Goyo for help files
autocmd BufRead /usr/local/share/nvim/runtime/doc/*,
  \$HOME/.local/share/nvim/site/autoload/plugged/*/doc/* :Goyo

" one ZQ fully exits out of Goyo when reading help files.
" (ordinarily, one would need to ZQ twice).
autocmd BufRead /usr/local/share/nvim/runtime/doc/*,
  \$HOME/.local/share/nvim/site/autoload/plugged/*/doc/* nnoremap ZQ :Goyo!\|q!

" shell script syntax for xsession and ksh files
autocmd BufRead $HOME/.xsession,$HOME/.config/ksh/* set filetype=sh

" no more automatic commenting on newline
autocmd VimEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" if vim-plug isn't installed, install it
if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall --sync | source "$HOME/.config/nvim/init.vim"
endif

" creates backup directory
if isdirectory(expand("$HOME/.local/share/nvim/backup")) != 1
  silent !mkdir -p $HOME/.local/share/nvim/backup
endif

" plugins
call plug#begin("$HOME/.local/share/nvim/site/autoload/plugged")
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree'
  Plug 'scrooloose/syntastic'
  Plug 'tpope/vim-surround'

  if $DISPLAY != ''
    Plug 'ap/vim-css-color'
    Plug 'dylanaraps/wal.vim'
    Plug 'kovetskiy/sxhkd-vim'
    Plug 'plasticboy/vim-markdown'
  endif

call plug#end()

" https://github.com/dylanaraps/pywal
if $DISPLAY != ''
  colorscheme wal
endif
