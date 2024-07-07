-- luacheck: globals vim

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "No automatic commenting on newlines.",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = {
		os.getenv("HOME") .. "/.Xresources",
		os.getenv("HOME") .. "/.Xdefaults",
	},
	callback = function()
		if os.getenv("DISPLAY") then
			local filename = vim.fn.expand("%:p")
			os.execute("xrdb " .. filename)
		end
	end,
	desc = "Reload Xresources and Xdefaults with xrdb(1)",
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.filetype == "help" then
			require("zen-mode").toggle({
				on_close = function()
					vim.cmd("q")
				end,
			})
		end
	end,
	desc = "ZenMode is enabled for help files.",
})

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = {
		"*.[0-9]",
		"*.3p",
	},
	callback = function()
		vim.opt.filetype = "nroff"
	end,
	desc = 'Set "nroff" filetype for man pages with file names that end in 0-9 or 3p',
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "/tmp/sh[a-zA-Z0-9]*",
	callback = function()
		vim.opt.filetype = "sh"
	end,
	desc = "Set command-line editing to sh filetype so it has syntax highlighting",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "/tmp/bash-fc.[a-zA-Z0-9]*",
	callback = function()
		vim.opt.filetype = "bash"
	end,
	desc = "Set command-line editing to bash filetype so it has syntax highlighting",
})
