vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- vim-gnupg configuration
-- https://github.com/jamessan/vim-gnupg/issues/119
-- https://github.com/jamessan/vim-gnupg/issues/32
-- NOTE: Using wrapper script because vim-gnupg always adds --use-agent for GPG >= 2.1,
-- but qubes-gpg-client doesn't support that flag
vim.g.GPGExecutable = vim.fn.expand("~/.local/bin/qubes-gpg-wrapper") .. " --trust-model always"
vim.g.GPGUsePipes = 1
vim.g.GPGDefaultRecipients = { "4A2144F748E4F5DC17C5E707F1B59F496EE704B0" }
