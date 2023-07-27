return {
	'nvim-telescope/telescope.nvim',
	lazy = true,
	tag = '0.1.2',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim',
			build = function()
				vim.cmd('!gmake')
			end
		},
	},
	keys = {
		{
			'<leader>ts',
			function()
				vim.cmd('Telescope')
			end,
		},
	},
}
