set autochdir
set backup
set backupdir     =$XDG_DATA_HOME/nvim/backup
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

" allow Markdown folds
let g:markdown_folding = 1

" run linters/syntax checks on open, but not on close
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" copy and paste to CLIPBOARD selection
vnoremap <C-c> "+y
nnoremap <C-p> "+P

" to protecc my left pinky finger
noremap ; :
noremap : ;

" plugin bindings
let mapleader=","

nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :FZF $HOME<CR>
nnoremap <leader>g :Goyo<CR>
nnoremap <leader>d :r !date '+\%F'<CR>

" spell-check set to <leader>o, 'o' for 'orthography':
nnoremap <leader>o :set spell! spelllang=en_us<CR>

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
autocmd BufWritePost $XDG_CONFIG_HOME/ksh/kshrc !. %
autocmd BufWritePost $XDG_CONFIG_HOME/sxhkd/sxhkdrc !pkill -USR1 sxhkd

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
if empty(glob('$XDG_CONFIG_HOME/nvim/site/autoload/plug.vim'))
  silent !curl -fLo "$XDG_CONFIG_HOME/nvim/site/autoload/plug.vim" --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall --sync | source "$XDG_CONFIG_HOME/nvim/init.vim"
endif

" creates backup directory
if isdirectory(expand("$XDG_DATA_HOME/nvim/backup")) != 1
  silent !mkdir -p $XDG_DATA_HOME/nvim/backup
endif

" plugins
call plug#begin("$XDG_DATA_HOME/nvim/site/autoload/plugged")
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
