-- Headless test bootstrap (Phase 5 / D-07..D-17).
-- Invoked via: nvim --headless -u tests/minimal_init.lua ...
-- DO NOT add my.* requires here — specs that need real config behavior
-- spawn a child via H.nvim_child (D-16, D-21).

-- D-07: locate plenary at the lazy data dir (single source of truth)
local plenary_dir = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
if vim.fn.isdirectory(plenary_dir) ~= 1 then
	io.stderr:write("plenary missing at " .. plenary_dir .. "\n")
	io.stderr:write("run `nvim --headless +Lazy! sync +qa` first\n")
	os.exit(1)
end
vim.opt.rtp:prepend(plenary_dir)

-- D-08: project lua/ on rtp (cwd-assumption per D-17)
vim.opt.rtp:prepend(vim.fn.getcwd())

-- D-09: helper require path so tests.spec.helpers resolves from project root
package.path = package.path .. ";./?.lua;./?/init.lua"

-- D-10: hermetic runtime opts
vim.opt.swapfile = false
vim.opt.shada = ""
vim.opt.more = false
vim.opt.shortmess:append("I")
