-- luacheck: globals vim

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
--
-- See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
vim.keymap.set("n", "<esc>", function()
	vim.cmd("nohlsearch")
end)

vim.keymap.set({ "v", "n" }, "<Space>", "<Nop>", { silent = true })

-- Smart j/k navigation for wrapped lines
-- Without count: move by visual lines (respects wrap)
-- With count: move by actual lines (for relative jumps)
vim.keymap.set(
	{ "n", "x" },
	"j",
	"v:count == 0 ? 'gj' : 'j'",
	{ expr = true, silent = true, desc = "Down (wrap-aware)" }
)
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrap-aware)" })

-- Undo break-points at punctuation
-- Creates granular undo history in insert mode instead of undoing entire paragraphs
vim.keymap.set("i", ",", ",<c-g>u", { desc = "Undo break-point at comma" })
vim.keymap.set("i", ".", ".<c-g>u", { desc = "Undo break-point at period" })
vim.keymap.set("i", ";", ";<c-g>u", { desc = "Undo break-point at semicolon" })

-- Consistent n/N search direction and auto-open folds
-- n always forward, N always backward regardless of / vs ?
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })

-- Keep selection when indenting in visual mode
vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to CLIPBOARD." })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy lines to CLIPBOARD." })

vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from CLIPBOARD (after cursor)." })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from CLIPBOARD (before cursor)." })

vim.keymap.set("", ";", ":", { desc = "Semicolon swapped with colon to protect pinky." })
vim.keymap.set("", ":", ";", { desc = "Colon swapped with semicolon to protect pinky." })

vim.keymap.set("n", "<leader>S", ":%s//g<Left><Left>", { desc = "Replace all." })

vim.keymap.set("n", "<leader>dws", function()
	vim.cmd("%s/\\s\\+$//e")
end, { desc = "Delete all trailing whitespace." })

vim.keymap.set("n", "<leader>dnl", function()
	vim.cmd("%s/\\n\\+\\%$//e")
end, { desc = "Delete all trailing newlines." })

vim.keymap.set("n", "<leader>fm", function()
	vim.cmd.Explore()
end, { desc = "NetRW (file manager)" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down a line." })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up a line." })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep cursor in the same place when joining lines." })

vim.keymap.set("n", "<leader>L", function()
	if vim.bo.filetype == "lazy" then
		vim.cmd.close()
	else
		require("lazy").show()
	end
end, { desc = "Toggle Lazy plugin manager." })

vim.keymap.set("n", "<leader>M", function()
	if vim.bo.filetype == "mason" then
		vim.cmd.close()
	else
		require("mason.ui").open()
	end
end, { desc = "Toggle Mason package manager." })

-- Terminal mode mappings
vim.keymap.set("t", "<C-Space>", "<C-\\><C-n>", { desc = "Toggle terminal mode" })
vim.keymap.set("n", "<C-Space>", function()
	if vim.bo.buftype == "terminal" then
		vim.cmd("startinsert")
	end
end, { desc = "Toggle terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Exit terminal + move left" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Exit terminal + move down" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Exit terminal + move up" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Exit terminal + move right" })

-- =============================================================================
-- Smart Window Resizing
-- =============================================================================
-- Press Alt+direction to push that edge in that direction.
-- Example: <M-l> pushes the right edge right (growing the window), unless
-- you're already at the rightmost position, in which case it shrinks.
--
-- Supports count prefix: 5<M-l> resizes by 5 * step instead of 1 * step.
-- Configure step size via vim.g.smart_resize_step (default: 2).
-- Implementation: lua/my/utils.lua (smart_resize, terminal_smart_resize, at_edge, get_resize_step).

-- Normal mode
vim.keymap.set("n", "<M-h>", function()
	require("my.utils").smart_resize("h")
end, { desc = "Smart resize left", silent = true })
vim.keymap.set("n", "<M-j>", function()
	require("my.utils").smart_resize("j")
end, { desc = "Smart resize down", silent = true })
vim.keymap.set("n", "<M-k>", function()
	require("my.utils").smart_resize("k")
end, { desc = "Smart resize up", silent = true })
vim.keymap.set("n", "<M-l>", function()
	require("my.utils").smart_resize("l")
end, { desc = "Smart resize right", silent = true })

-- Terminal mode (exit to normal first using <C-\><C-n> pattern)
-- Set vim.g.smart_resize_terminal_stay_normal = true to stay in normal mode after resize
vim.keymap.set("t", "<M-h>", require("my.utils").terminal_smart_resize("h"), { desc = "Smart resize left", silent = true })
vim.keymap.set("t", "<M-j>", require("my.utils").terminal_smart_resize("j"), { desc = "Smart resize down", silent = true })
vim.keymap.set("t", "<M-k>", require("my.utils").terminal_smart_resize("k"), { desc = "Smart resize up", silent = true })
vim.keymap.set("t", "<M-l>", require("my.utils").terminal_smart_resize("l"), { desc = "Smart resize right", silent = true })

-- =================================
-- Diagnostic Navigation by Severity
-- =================================
-- ]e/[e for errors only, ]w/[w for warnings only. Implementation: lua/my/utils.lua (diagnostic_goto).
vim.keymap.set("n", "]e", require("my.utils").diagnostic_goto(true, "ERROR"), { desc = "Next error" })
vim.keymap.set("n", "[e", require("my.utils").diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
vim.keymap.set("n", "]w", require("my.utils").diagnostic_goto(true, "WARN"), { desc = "Next warning" })
vim.keymap.set("n", "[w", require("my.utils").diagnostic_goto(false, "WARN"), { desc = "Prev warning" })
