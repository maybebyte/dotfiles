-- Define variables so that even if they're undefined by a specific user, neovim
-- will know what to do with them.
vim.env.XDG_STATE_HOME = os.getenv("HOME") .. '/.local/state'

-- Make a backup of a file before writing, and leave it present in backupdir.
vim.opt.backup = true
vim.opt.backupdir = os.getenv("XDG_STATE_HOME") .. '/nvim/backup'

-- Ignore white space changes when showing differences between files.
vim.opt.diffopt:append("iwhiteall")

-- Indentation settings.
--
-- When pressing <TAB>, it should insert a tab character. Each tab should be
-- four spaces wide.
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Force myself to use folds, by opening a file with some of the folds closed.
vim.opt.foldlevelstart = 1

-- Search settings.
--
-- When searching, do so case insensitively unless the search starts with an
-- uppercase character.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Disable status line.
vim.opt.laststatus = 0

-- Break long lines so they wrap without changing their contents. Do so at the
-- same indentation level.
vim.opt.breakindent = true
vim.opt.linebreak = true

-- I don't trust modelines.
-- https://security.stackexchange.com/questions/36001/vim-modeline-vulnerabilities
vim.opt.modelines = 0
vim.opt.modeline = false

-- Number each line. The current line is the total line number, and every
-- surrounding number is relative to that line to make it easy to know where to
-- jump for a 'gg', for instance.
vim.opt.number = true
vim.opt.relativenumber = true

-- Split below and to the right by default.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Lines are 80 characters long, and will be broken after that.
vim.opt.textwidth = 80

-- Save edit history to an undo file.
vim.opt.undofile = true
