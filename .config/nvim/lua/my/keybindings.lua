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
	{ 'n', 'v' }, '<leader>pt',
	function()
		vim.cmd('%!perltidy -q')
	end,
	{ desc = 'Format perl scripts using perltidy(1)' }
)

vim.keymap.set(
	{ 'n', 'v' }, '<leader>sf',
	function()
		vim.cmd('%!shfmt -s -i 0 -ci -sr -bn')
	end,
	{ desc = 'Format shell scripts using shfmt(1)' }
)

vim.keymap.set(
	'n', '<leader>ts',
	function()
		vim.cmd('Telescope')
	end,
	{ desc = 'Run Telescope.'}
)

vim.keymap.set(
	'n', '<leader>d',
	function()
		vim.api.nvim_put( { os.date('%F') }, 'l', true, false)
	end,
	{ desc = 'Insert current date.' }
)

vim.keymap.set(
	'n', '<leader>w',
	function()
		vim.cmd('%s/\\s\\+$//e')
	end,
	{ desc = 'Delete all trailing whitespace.' }
)

vim.keymap.set(
	'n', '<leader>e',
	function()
		vim.cmd('%s/\\n\\+\\%$//e')
	end,
	{ desc = 'Delete all trailing newlines.' }
)

vim.keymap.set(
	'n', '<leader>o',
	function()
		-- There's probably a better way to do this in Lua, but I don't know it
		-- right now.
		if vim.o.spell == true then
			vim.o.spell = false
		else
			vim.o.spell = true
		end
		vim.opt.spelllang = 'en_us'
	end,
	{ desc = "Toggle spell check ('o' for orthography)." }
)

vim.keymap.set(
	'n', '<leader>g',
	function()
		-- Preserve original background rather than neovim's global
		-- default of "dark"
		-- https://github.com/junegunn/goyo.vim/issues/78
		local previous_background = vim.o.background
		vim.cmd('Goyo')
		vim.opt.background = previous_background
	end,
	{ desc = 'Toggle Goyo.' }
)

vim.keymap.set(
	'n', '<leader>n',
	function()
		vim.cmd('NERDTreeToggle')
	end,
	{ desc = 'Toggle NERD Tree.' }
)

vim.keymap.set(
	{ 'x', 'n' }, 'ga', '<Plug>(EasyAlign)',
	{
		desc = 'Start interactive EasyAlign in visual mode and '
			.. 'for motions/text objects (e.g. vipga, gaip)'
	}
)
