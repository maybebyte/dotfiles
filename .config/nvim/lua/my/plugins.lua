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
		Plug 'plasticboy/vim-markdown'
		Plug 'lervag/vimtex'
		Plug 'jamessan/vim-gnupg'
		Plug 'jackMort/ChatGPT.nvim'

		-- Dependencies of ChatGPT.nvim
		Plug 'MunifTanjim/nui.nvim'
		Plug 'nvim-lua/plenary.nvim'
		Plug('nvim-telescope/telescope.nvim', { tag = '0.1.2'})

		-- Dependencies of telescope.nvim
		Plug('nvim-treesitter/nvim-treesitter', {
			['do'] = function()
				vim.cmd('TSUpdate')
			end
		})
		Plug('nvim-telescope/telescope-fzf-native.nvim', {
			['do'] = function()
				vim.cmd('!gmake')
			end
		})
	end

	vim.call('plug#end')
else
	vim.api.nvim_err_writeln(plugin_file .. ' not found. Plugins are disabled.')
end

require('chatgpt').setup({
	openai_params = {
		max_tokens = 500,
	},
	api_key_cmd = "gpg --decrypt " .. vim.env.HOME .. "/passwords/api/chatgpt.txt.gpg"
})

-- Begin nvim-treesitter section
require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'c',
		'css',
		--'diff', -- this assumes git, so disable for now
		'html',
		'lua',
		'make',
		'python',
		'query',
		'sxhkdrc',
		'vim',
		'vimdoc',
	},
	sync_install = false,
	auto_install = false,

	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at
		-- the same time.
		--
		-- Set this to `true` if you depend on 'syntax' being enabled
		-- (like for indentation).
		--
		-- Using this option may slow down your editor, and you may see
		-- some duplicate highlights.
		--
		-- Instead of true it can also be a list of languages.
		additional_vim_regex_highlighting = false,
	}
})
