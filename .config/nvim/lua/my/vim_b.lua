-- luacheck: globals vim

-- Disable < auto-pairs. Doesn't work with HTML and will be a pain
-- otherwise (shell scripting requires that character for redirection)
vim.b.coc_pairs_disabled = '<'
