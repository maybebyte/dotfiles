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
set backupdir   =~/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =~/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =~/.vim/files/undo/
set viminfo ='100,n~/.vim/files/info/viminfo

" automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" automatically reload Xresources
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" if vim-plug isn't installed, install it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.vim/plugged')
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
