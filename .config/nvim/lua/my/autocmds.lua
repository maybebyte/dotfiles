-- luacheck: globals vim

vim.api.nvim_create_autocmd('VimEnter', {
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
	desc = 'Format perl scripts using perltidy(1)'
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'sh',
	callback = function()
		vim.keymap.set({ 'n', 'v' }, '<leader>s', ':%!shfmt -s -i 0 -ci -sr -bn<CR>')
	end,
	desc = 'Format shell scripts using shfmt(1)'
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = {
		os.getenv('HOME') .. '/.Xresources',
		os.getenv('HOME') .. '/.Xdefaults'
	},
	callback = function()
		if os.getenv('DISPLAY') then
			local filename = vim.fn.expand('%:p')
			os.execute('xrdb ' .. filename)
		end
	end,
	desc = 'Reload Xresources and Xdefaults with xrdb(1)'
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = vim.env.XDG_CONFIG_HOME .. '/sxhkd/sxhkdrc',
	callback = function()
		if os.getenv('DISPLAY') then
			os.execute('pkill -USR1 sxhkd')
		end
	end,
	desc = 'Reload sxhkd(1) keybindings'
})

vim.api.nvim_create_autocmd('BufWritePost', {
	pattern = {
		vim.env.WEBSITE_SRC_DIR .. '/*.html',
		vim.env.WEBSITE_SRC_DIR .. '/*.css',
		vim.env.WEBSITE_SRC_DIR .. '/*.txt',
	},
	callback = function()
		local absolute_path = vim.fn.expand('%:p')
		local filename_only = vim.fn.expand('%:t')

		local relative_dirname =
			string.gsub(vim.fn.expand('%:p:h'), vim.env.WEBSITE_SRC_DIR, '')

		local destination_dir = vim.env.WEBSITE_DEST_DIR .. relative_dirname

		os.execute('mkdir -p -- ' .. destination_dir)
		if not os.execute('cp -- ' .. absolute_path .. ' ' .. destination_dir) then
			vim.api.nvim_err_writeln(
				'Failed to copy ' .. filename_only .. 'to ' .. destination_dir
			)
		end
	end,
	desc = 'Automatically copy website files to web directory'
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = 'help',
	callback = function()
		vim.schedule(function()
			vim.cmd('Goyo')
		end)
	end,
	desc = 'Goyo is enabled for help files.'
})

-- QuitPre takes place after writes to the buffer, so :wq is still safe.
--
-- Also see:
-- https://github.com/junegunn/goyo.vim/issues/16
-- https://github.com/junegunn/goyo.vim/wiki/Customization
vim.api.nvim_create_autocmd('QuitPre', {
	callback = function()
		if vim.call('exists', '#goyo') then
			vim.cmd('Goyo!|q!')
		end
	end,
	desc = 'Instead of requiring two quits to exit a Goyo window, one will do.'
})


-- TODO: there may be a way to refactor these BufNewFile autocmds to
-- reduce duplicated code.
vim.api.nvim_create_autocmd('BufNewFile', {
	pattern = '*.pl',
	callback = function()
		local skeleton = vim.env.XDG_DATA_HOME .. '/nvim' .. '/skel' .. '/skel.pl'
		local f = assert(io.open(skeleton, 'r'))
		local t = f:read('a')
		f:close()
		vim.api.nvim_paste(t, false, -1)
	end,
	desc = 'Insert Perl boilerplate into files ending with ".pl"'
})

vim.api.nvim_create_autocmd('BufNewFile', {
	pattern = '*.html',
	callback = function()
		local skeleton = vim.env.XDG_DATA_HOME .. '/nvim' .. '/skel' .. '/skel.html'
		local f = assert(io.open(skeleton, 'r'))
		local t = f:read('a')
		f:close()
		vim.api.nvim_paste(t, false, -1)
	end,
	desc = 'Insert HTML boilerplate into files ending with ".html"'
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
-- 	pattern = vim.env.XDG_CONFIG_HOME .. '/ksh/*',
-- 	callback = function()
-- 		local filename = vim.fn.expand('%:p')
-- 		os.execute('. ' .. filename)
-- 	end,
-- 	desc = 'Reload ksh configuration if edited'
-- })
