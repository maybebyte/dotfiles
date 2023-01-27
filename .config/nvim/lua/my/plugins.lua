-- luacheck: globals vim
local Plug = vim.fn['plug#']

-- plugins
vim.call('plug#begin', vim.env.XDG_DATA_HOME .. '/nvim/site/autoload/plugged')

Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'

if os.getenv('DISPLAY') then
	Plug 'ap/vim-css-color'
	Plug 'dylanaraps/wal.vim'
	Plug 'kovetskiy/sxhkd-vim'
	Plug 'plasticboy/vim-markdown'
	Plug 'lervag/vimtex'
	Plug 'jamessan/vim-gnupg'
end

vim.call('plug#end')

-- https://github.com/dylanaraps/pywal
if os.getenv('DISPLAY') then
	vim.cmd.colorscheme('wal')
end
