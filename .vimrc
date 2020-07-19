set nocompatible
set number relativenumber
set splitbelow splitright
set showcmd
set showmode
set incsearch
set hlsearch
set wrapscan
set ttyfast
set lazyredraw
set autoindent
set ignorecase
set smartcase
set wildmode=longest,list,full
set tabstop=4
set shiftwidth=4
set linebreak
set breakindent
set noerrorbells
set autochdir
set hidden
set modelines=0
set nomodeline
set diffopt+=iwhite
set encoding=utf-8
highlight MatchParen ctermbg=4
filetype plugin indent on
syntax on
let mapleader=","
vnoremap <C-c> "+y
map <C-p> "+P

" to protecc my left pinky finger
noremap ; :
noremap : ;


set backup
set backupdir   =~/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =~/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =~/.vim/files/undo/
set viminfo ='100,n~/.vim/files/info/viminfo

" no trailing space
autocmd BufWritePre * %s/\s\+$//e

" automatically reload Xresources
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" gets rid of difficult to read syntax highlighting in vimdiff
if &diff
    syntax off
endif

"noremap <leader>n :NERDTreeToggle
"noremap <leader>f :FZF
"let g:airline_theme='minimalist'
