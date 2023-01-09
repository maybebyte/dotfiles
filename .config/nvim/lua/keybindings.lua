-- luacheck: globals vim

-- Copy and paste from CLIPBOARD.
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-p>', '"+P')

-- Protect my left pinky.
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

-- Replace all is aliased to S.
vim.keymap.set('n', 'S', ':%s//g<Left><Left>')

-- Delete all trailing whitespace.
vim.keymap.set('n', '<leader>w', ':%s/\\s\\+$//e<CR>')

-- Delete all trailing newlines.
vim.keymap.set('n', '<leader>e', ':%s/\\n\\+\\%$//e<CR>')

-- Toggle spell check ('o' for orthography).
vim.keymap.set('n', '<leader>o', ':set spell! spelllang=en_us<CR>')

-- Toggle Goyo.
vim.keymap.set('n', '<leader>g', ':Goyo<CR>')

-- Toggle NERD Tree.
vim.keymap.set('n', '<leader>n', ':NERDTreeToggle<CR>')

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
