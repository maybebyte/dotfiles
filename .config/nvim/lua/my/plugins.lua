-- luacheck: globals vim

local plugin_file = vim.env.XDG_DATA_HOME .. '/nvim/site/autoload/plug.vim'

if os.rename(plugin_file, plugin_file) then
	local Plug = vim.fn['plug#']

	-- plugins
	vim.call('plug#begin', vim.env.XDG_DATA_HOME .. '/nvim/site/autoload/plugged')

	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/vim-easy-align'
	Plug 'scrooloose/nerdcommenter'
	Plug 'scrooloose/nerdtree'
	Plug 'scrooloose/syntastic'
	Plug 'tpope/vim-surround'
	Plug('neoclide/coc.nvim', { branch = 'release' })

	if os.getenv('DISPLAY') then
		Plug 'altercation/solarized'
		Plug 'ap/vim-css-color'
		Plug 'kovetskiy/sxhkd-vim'
		Plug 'plasticboy/vim-markdown'
		Plug 'lervag/vimtex'
		Plug 'jamessan/vim-gnupg'
	end

	vim.call('plug#end')
else
	vim.api.nvim_err_writeln(plugin_file .. ' not found. Plugins are disabled.')
end
