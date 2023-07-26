local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- XXX: Probably not a good way to do this, but it works for now.
local function telescope_init()
	return
	{ 'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim',
				build = function()
					vim.cmd('!gmake')
				end
			},
		},
	}
end

require("lazy").setup({
	'jamessan/vim-gnupg',

	{ 'nvim-treesitter/nvim-treesitter',
		build = function()
			vim.cmd('TSUpdate')
		end,
		config = function()
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
		end,
	},

	{ 'scrooloose/nerdcommenter',
		event = 'VeryLazy',
	},

	{ 'scrooloose/syntastic',
		event = 'VeryLazy',
	},

	{ 'tpope/vim-surround',
		event = 'VeryLazy',
	},

	{ 'neoclide/coc.nvim',
		branch = 'release',
		event = 'VeryLazy',
	},

	{ 'tpope/vim-surround',
		event = 'VeryLazy',
	},

	{ 'scrooloose/nerdtree',
		lazy = true,
		cmd = {
			'NERDTree',
			'NERDTreeVCS',
			'NERDTreeFromBookmark',
			'NERDTreeToggle',
			'NERDTreeToggleVCS',
			'NERDTreeFocus',
			'NERDTreeMirror',
			'NERDTreeClose',
			'NERDTreeFind',
			'NERDTreeCWD',
			'NERDTreeRefreshRoot',
		},
		keys = {
			{
				'<leader>ntt',
				function()
					vim.cmd('NERDTreeToggle')
				end,
			},
		},
	},

	{ 'junegunn/vim-easy-align',
		lazy = true,
		cmd = 'EasyAlign',
		keys = {
			{
				'ga',
				'<Plug>(EasyAlign)',
				mode = { 'x', 'n' },
			},
		},
	},

	{ 'junegunn/goyo.vim',
		lazy = true,
		ft = 'help',
		cmd = 'Goyo',
		keys = {
			{
				'<leader>g',
				function()
					-- Preserve previous background rather than neovim's global
					-- default of "dark"
					-- https://github.com/junegunn/goyo.vim/issues/78
					local previous_background = vim.o.background
					vim.cmd('Goyo')
					vim.opt.background = previous_background
				end,
			},
		},
	},

	{ 'lervag/vimtex',
		lazy = true,
		ft = 'tex',
	},

	{ 'plasticboy/vim-markdown',
		lazy = true,
		ft = 'markdown',
	},

	{ 'jackMort/ChatGPT.nvim',
		lazy = true,
		cmd = {
			"ChatGPT",
			"ChatGPTActAs",
			"ChatGPTCompleteCode",
			"ChatGPTEditWithInstructions",
			"ChatGPTRun",
		},
		config = function()
			require('chatgpt').setup({
				openai_params = {
					max_tokens = 500,
				},
				api_key_cmd = "gpg --decrypt "
					.. vim.env.HOME
					.. "/passwords/api/chatgpt.txt.gpg"
			})
		end,
		dependencies = {
			'MunifTanjim/nui.nvim',
			telescope_init(),
		},
	},

	telescope_init(),
})
