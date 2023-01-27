-- luacheck: globals vim

vim.keymap.set(
	'v', '<C-c>', '"+y',
	{ desc = 'Copy to CLIPBOARD.' }
)
vim.keymap.set(
	'n', '<C-p>', '"+P',
	{ desc = 'Paste from CLIPBOARD.' }
)

vim.keymap.set(
	'', ';', ':',
	{ desc = 'Semicolon swapped with colon to protect pinky.' }
)
vim.keymap.set(
	'', ':', ';',
	{ desc = 'Colon swapped with semicolon to protect pinky.' }
)

vim.keymap.set(
	'n', 'S', ':%s//g<Left><Left>',
	{ desc = 'Replace all.' }
)

vim.keymap.set(
	'n', '<leader>d', ':r !date +\\%F<CR>',
	{ desc = 'Insert current date.' }
)

vim.keymap.set(
	'n', '<leader>w', ':%s/\\s\\+$//e<CR>',
	{ desc = 'Delete all trailing whitespace.' }
)

vim.keymap.set(
	'n', '<leader>e', ':%s/\\n\\+\\%$//e<CR>',
	{ desc = 'Delete all trailing newlines.' }
)

vim.keymap.set(
	'n', '<leader>o', ':set spell! spelllang=en_us<CR>',
	{ desc = "Toggle spell check ('o' for orthography)." }
)

vim.keymap.set(
	'n', '<leader>g', ':Goyo<CR>',
	{ desc = 'Toggle Goyo.' }
)

vim.keymap.set(
	'n', '<leader>n', ':NERDTreeToggle<CR>',
	{ desc = 'Toggle NERD Tree.' }
)

vim.keymap.set(
	{ 'x', 'n' }, 'ga', '<Plug>(EasyAlign)',
	{
		desc = 'Start interactive EasyAlign in visual mode and '
			.. 'for motions/text objects (e.g. vipga, gaip)'
	}
)
