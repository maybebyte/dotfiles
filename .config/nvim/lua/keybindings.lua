-- Copy and paste from CLIPBOARD.
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('n', '<C-p>', '"+P')

-- Protect my left pinky.
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', ':', ';')

-- Replace all is aliased to S.
vim.keymap.set('n', 'S', ':%s//g<Left><Left>')

-- Toggle Goyo
vim.keymap.set('n', '<leader>g', ':Goyo<CR>')

-- Toggle NERD Tree
vim.keymap.set('n', '<leader>n', ':NERDTreeToggle<CR>')
