-- luacheck: globals vim

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'perl',
	callback = function()
		vim.keymap.set({ 'n', 'v' }, '<leader>t', ':%!perltidy -q<CR>')
	end,
	desc = "Format perl scripts using perltidy(1)"
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'sh',
	callback = function()
		vim.keymap.set({ 'n', 'v' }, '<leader>s', ':%!shfmt -s -i 0 -ci -sr -bn<CR>')
	end,
	desc = "Format shell scripts using shfmt(1)"
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = {
		os.getenv("HOME") .. '/.Xresources',
		os.getenv("HOME") .. '/.Xdefaults'
	},
	callback = function()
		if os.getenv("DISPLAY") then
			local filename = vim.fn.expand('%:p')
			os.execute('xrdb ' .. filename)
		end
	end,
	desc = 'Reload Xresources and Xdefaults with xrdb(1)'
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = os.getenv("XDG_CONFIG_HOME") .. '/sxhkd/sxhkdrc',
	callback = function()
		if os.getenv("DISPLAY") then
			os.execute('pkill -USR1 sxhkd')
		end
	end,
	desc = 'Reload sxhkd(1) keybindings'
})

-- This doesn't seem to work using either the vim or neovim backend.
--vim.api.nvim_create_autocmd('BufWritePost', {
--	pattern = os.getenv("XDG_CONFIG_HOME") .. '/ksh/*',
--	callback = function()
--		local filename = vim.fn.expand('%:p')
--		os.execute('. ' .. filename)
--	end,
--	desc = 'Reload ksh configuration if edited'
--})
