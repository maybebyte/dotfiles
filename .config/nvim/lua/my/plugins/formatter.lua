return {
	'mhartington/formatter.nvim',
	init = function()
		require('formatter').setup({
			filetype = {
				css = {
					require('formatter.filetypes.css').prettier
				},
				html = {
					require('formatter.filetypes.html').prettier
				},
				json = {
					require('formatter.filetypes.json').prettier
				},
				markdown = {
					require('formatter.filetypes.markdown').prettier
				},
				python = {
					require('formatter.filetypes.python').yapf
				},
				yaml = {
					require('formatter.filetypes.yaml').prettier
				},
			}
		})
	end
}
