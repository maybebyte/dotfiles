-- luacheck: globals vim

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'perl',
	callback = function()
		vim.keymap.set({'n', 'v'}, '<leader>t', ':%!perltidy -q<CR>')
	end,
	desc = "Format perl scripts using perltidy(1)"
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'sh',
	callback = function()
		vim.keymap.set({'n', 'v'}, '<leader>s', ':%!shfmt -s -i 0 -ci -sr -bn<CR>')
	end,
	desc = "Format shell scripts using shfmt(1)"
})
