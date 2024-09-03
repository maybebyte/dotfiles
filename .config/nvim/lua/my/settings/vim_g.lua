-- luacheck: globals vim

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- https://github.com/jamessan/vim-gnupg/issues/119
-- https://github.com/jamessan/vim-gnupg/issues/32
vim.g.GPGUsePipes = 1
vim.g.GPGDefaultRecipients = { "90965AE120F8E848979DEA4853670DEBCF375780" }
