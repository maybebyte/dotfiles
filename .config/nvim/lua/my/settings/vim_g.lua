-- luacheck: globals vim

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- https://github.com/jamessan/vim-gnupg/issues/119
-- https://github.com/jamessan/vim-gnupg/issues/32
vim.g.GPGUsePipes = 1
vim.g.GPGDefaultRecipients = { "4A2144F748E4F5DC17C5E707F1B59F496EE704B0" }
