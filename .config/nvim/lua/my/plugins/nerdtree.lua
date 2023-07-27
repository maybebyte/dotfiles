-- luacheck: globals vim

return {
	'scrooloose/nerdtree',
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
}
