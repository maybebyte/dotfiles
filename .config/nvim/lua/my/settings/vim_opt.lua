-- luacheck: globals vim

vim.opt.backup = true
vim.opt.backupdir = vim.env.XDG_STATE_HOME .. "/nvim/backup"

vim.opt.diffopt:append("iwhiteall")

-- Keep signcolumn on by default.
vim.opt.signcolumn = "yes"

-- Minimum number of lines to keep above and below cursor.
vim.opt.scrolloff = 10

vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.foldlevelstart = 1

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.laststatus = 0

vim.opt.breakindent = true
vim.opt.linebreak = true

-- I don't trust modelines.
-- https://security.stackexchange.com/questions/36001/vim-modeline-vulnerabilities
vim.opt.modelines = 0
vim.opt.modeline = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.termguicolors = true

vim.opt.textwidth = 72

vim.opt.undofile = true

vim.opt.updatetime = 300

vim.opt.list = true
vim.opt.listchars = {
    space = '·',
    tab = '┊ ',
    trail = '•',
    extends = '⟩',
    precedes = '⟨',
    nbsp = '◦',
}
