-- luacheck: globals vim

vim.api.nvim_create_autocmd('VimEnter', {
	pattern = '*',
	callback = function()
		vim.opt.formatoptions:remove( { 'c', 'r', 'o' } )
	end,
	desc = 'No automatic commenting on newlines.'
})

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

-- Not currently used, but good to keep around in case I start transcribing
-- music again.
-- vim.api.nvim_create_autocmd('BufWritePost', {
-- 	pattern = '*.ly',
-- 	callback = function()
-- 		local filename = vim.fn.expand('%:p')
-- 		os.execute('lilypond ' .. filename)
-- 	end,
-- 	desc = 'Compile lilypond files (related to music transcription).'
-- })

-- This doesn't seem to work, regardless of whether I use vimscript or lua, but
-- it's kept around in case I ever figure that out.
-- vim.api.nvim_create_autocmd('BufWritePost', {
-- 	pattern = os.getenv("XDG_CONFIG_HOME") .. '/ksh/*',
-- 	callback = function()
-- 		local filename = vim.fn.expand('%:p')
-- 		os.execute('. ' .. filename)
-- 	end,
-- 	desc = 'Reload ksh configuration if edited'
-- })
