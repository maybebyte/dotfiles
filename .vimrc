syntax on
highlight MatchParen ctermbg=4
filetype plugin indent on

 " can jump to specific lines
set number relativenumber

 " more intuitive window splitting
set splitbelow splitright

" vim not vi
set nocompatible
set mouse=

" search
set incsearch
set hlsearch
set wrapscan
set ignorecase
set smartcase

" screen will not be redrawn while executing {macros,registers,other
" untyped commands}
set lazyredraw
set ttyfast
set autoindent

" prevents me from getting upset with an inanimate object
set noerrorbells

" https://security.stackexchange.com/questions/36001/vim-modeline-vulnerabilities
set modelines=0
set nomodeline

" ignore white space changes
set diffopt+=iwhite

" readable code
set encoding=utf-8
set tabstop=2
set shiftwidth=2
set textwidth=72
set expandtab
set showbreak=>\
set nowrap

" :h fo-table explains these options.
set formatoptions=tcqro2b1jp

" copy and paste to CLIPBOARD selection
vnoremap <C-c> "+y
nnoremap <C-p> "+P

" to protecc my left pinky finger
noremap ; :
noremap : ;

" plugin bindings
let mapleader=","
nnoremap <leader>n :NERDTreeToggle
nnoremap <leader>f :FZF
nnoremap <leader>g :Goyo

" Spell-check set to <leader>o, 'o' for 'orthography':
nnoremap <leader>o :set spell! spelllang=en_us

" for reverting edits and other conveniences
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =.vimbak
set directory   =$HOME/.vim/files/swap/
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo ='100,n$HOME/.vim/files/info/viminfo

" automatically deletes all trailing whitespace and newlines at end of
" file on save.
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" automatically reload configs
autocmd BufWritePost $HOME/.Xresources,$HOME/.Xdefaults !xrdb %
autocmd BufWritePost $HOME/.kshrc !. $HOME/.kshrc
autocmd BufWritePost $HOME/.config/sxhkd/sxhkdrc !pkill -USR1 sxhkd
autocmd BufWritePost index.md,about-me.md,software.md,selfhosting.md,projects.md,clues.md,_header.html,_footer.html ! ssg5 ~/builds/website_md ~/builds/website "A Missing Link" "https://amissing.link" && sh $HOME/bin/fmt_site

" conform to https://google.github.io/styleguide/shellguide.html
autocmd FileType sh set tabstop=2 shiftwidth=2 textwidth=80

" no more ugly status bar, tmux covers this.
autocmd VimEnter * set laststatus=0

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
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'dylanaraps/wal.vim'
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color'
Plug 'kovetskiy/sxhkd-vim'
call plug#end()

" https://github.com/dylanaraps/pywal
colorscheme wal
