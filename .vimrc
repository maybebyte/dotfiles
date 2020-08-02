set number relativenumber " can jump to specific lines
set splitbelow splitright " more intuitive window splitting
set nocompatible    " vim not vi
set mouse=          " no mouse
set incsearch       " incremental search
set hlsearch        " highlight when searching
set wrapscan        " wrap at the end of a search
set ttyfast         " indicates a fast terminal connection
set lazyredraw      " screen will not be redrawn while executing {macros,registers,other untyped commands}
set autoindent      " detects indentation when creating newline
set ignorecase      " ignores case when searching
set smartcase       " with the exception of capital letters at start of search
set tabstop=4       " tab is 4 spaces
set shiftwidth=4    " 4 spaces for autoindent
set expandtab       " tabs are expanded into spaces
set noerrorbells    " prevents me from getting upset with an inanimate object
set modelines=0     " https://security.stackexchange.com/questions/36001/vim-modeline-vulnerabilities
set nomodeline      " ^
set diffopt+=iwhite " ignore white space changes
set encoding=utf-8
syntax on
highlight MatchParen ctermbg=4
filetype plugin indent on
let mapleader=","

" copy and paste to CLIPBOARD selection
vnoremap <C-c> "+y
map <C-p> "+P

" to protecc my left pinky finger
noremap ; :
noremap : ;

" plugin bindings
noremap <leader>n :NERDTreeToggle
noremap <leader>f :FZF
noremap <leader>g :Goyo

" for reverting edits
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo ='100,n$HOME/.vim/files/info/viminfo

" automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" automatically reload configs
autocmd BufWritePost $HOME/.Xresources,$HOME/.Xdefaults !xrdb %
autocmd BufWritePost $HOME/.kshrc !. $HOME/.kshrc
autocmd BufWritePost $HOME/.config/sxhkd/sxhkdrc !pkill -USR1 sxhkd

" disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" if vim-plug isn't installed, install it
if empty(glob('$HOME/.vim/autoload/plug.vim'))
  silent !curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source "$HOME/.vimrc"
endif

call plug#begin("$HOME/.vim/plugged")
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'valloric/youcompleteme'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'dylanaraps/wal.vim'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'ap/vim-css-color'
Plug 'kovetskiy/sxhkd-vim'
call plug#end()

" https://github.com/dylanaraps/pywal
colorscheme wal
