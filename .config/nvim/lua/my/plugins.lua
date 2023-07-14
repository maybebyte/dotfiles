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
		Plug 'kovetskiy/sxhkd-vim'
		Plug 'plasticboy/vim-markdown'
		Plug 'lervag/vimtex'
		Plug 'jamessan/vim-gnupg'
		Plug 'jackMort/ChatGPT.nvim'
		-- Dependencies of ChatGPT.nvim
		Plug 'MunifTanjim/nui.nvim'
		Plug 'nvim-lua/plenary.nvim'
		Plug('nvim-telescope/telescope.nvim', { tag = '0.1.2'})
	end

	vim.call('plug#end')
else
	vim.api.nvim_err_writeln(plugin_file .. ' not found. Plugins are disabled.')
end

require("chatgpt").setup({
    api_key_cmd = "gpg --decrypt " .. vim.fn.expand("$HOME") .. "/passwords/api/chatgpt.txt.gpg"
})
