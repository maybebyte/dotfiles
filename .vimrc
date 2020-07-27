set nocompatible " vi not vim
set mouse= " no mouse
set number relativenumber " can jump to specific lines
set splitbelow splitright
set incsearch " incremental search
set hlsearch " highlight when searching
set wrapscan " wrap at the end of a search
set ttyfast " indicates a fast terminal connection
set lazyredraw
set autoindent
set ignorecase
set smartcase
set wildmode=longest,list,full
set tabstop=4
set shiftwidth=4
set expandtab
set linebreak
set breakindent
set noerrorbells
set modelines=0
set nomodeline
set diffopt+=iwhite
set encoding=utf-8
highlight MatchParen ctermbg=4
filetype plugin indent on
syntax on
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
Plug 'tpope/vim-surround' "
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

colorscheme wal
