-- luacheck: globals vim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require('my.plugins.vim-gnupg'),
	require('my.plugins.treesitter'),
	require('my.plugins.nerdcommenter'),
	require('my.plugins.lsp-zero'),
	require('my.plugins.vim-surround'),
	require('my.plugins.nerdtree'),
	require('my.plugins.vim-easy-align'),
	require('my.plugins.goyo'),
	require('my.plugins.vimtex'),
	require('my.plugins.vim-markdown'),
	require('my.plugins.chatgpt'),
	require('my.plugins.telescope'),
	require('my.plugins.harpoon'),
	require('my.plugins.undotree'),
	require('my.plugins.formatter'),
	require('my.plugins.nvim-lint'),
})
