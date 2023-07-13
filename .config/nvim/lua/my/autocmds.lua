-- luacheck: globals vim

-- Autocommands are used to execute commands automatically in response
-- to certain events. This file configures various autocommands for
-- different scenarios.

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

-- QuitPre autocmd
-- This autocmd triggers before vim exits.
-- It is used to exit from Goyo mode before quitting vim.
--
-- Also see:
-- https://github.com/junegunn/goyo.vim/issues/16
-- https://github.com/junegunn/goyo.vim/wiki/Customization
vim.api.nvim_create_autocmd('QuitPre', {
	callback = function()
		if vim.call('exists', '#goyo') then
			-- Preserve original background rather than neovim's global
			-- default of "dark"
			-- https://github.com/junegunn/goyo.vim/issues/78
			local previous_background = vim.o.background

			-- If Goyo mode is enabled, disable it and then quit vim
			vim.cmd('Goyo!|q!')

			vim.opt.background = previous_background
		end
	end,
	desc = 'Automatically exit Goyo mode before quitting vim'
})

-- FileType autocmd
-- This autocmd triggers when the filetype of the buffer changes.
-- It is used to automatically load filetype-specific skeletons into new
-- files.
vim.api.nvim_create_autocmd('FileType', {
	pattern = {
		'perl',
		'nroff',
		'html',
	},
	callback = function()
		-- Validate if current buffer is empty
		if vim.api.nvim_buf_line_count(0) == 1 then
			if vim.api.nvim_get_current_line() == '' then
				-- Read skeleton file based on the filetype
				-- and paste its content into the buffer
				local skeleton_file = os.getenv('HOME')
					.. '/.local/share/nvim/skel/'
					.. vim.bo.filetype
				print(skeleton_file)
				vim.api.nvim_buf_set_lines(0, 0, -1, false,
					vim.fn.readfile(skeleton_file))
			end
		end
	end,
	desc = 'Load filetype-specific skeleton for new files'
})

vim.api.nvim_create_autocmd('BufNewFile', {
	pattern = {
		'*.[0-9]',
		'*.3p',
	},
	callback = function()
		vim.opt.filetype = 'nroff'
	end,
	desc = 'Set "nroff" filetype for man pages with file names that end in 0-9 or 3p'
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
