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
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up (wrap-aware)" })

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

vim.keymap.set("n", "<leader>o", function()
	if vim.o.spell == true then
		vim.o.spell = false
	else
		vim.o.spell = true
	end
	vim.opt.spelllang = "en_us"
end, { desc = "Toggle spell check ('o' for orthography)." })

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

-- User-configurable resize step (set vim.g.smart_resize_step to override)
local function get_resize_step()
	return vim.g.smart_resize_step or 2
end

-- Uses winnr() to detect edges without changing focus or triggering autocommands
local function at_edge(dir)
	return vim.fn.winnr() == vim.fn.winnr(dir)
end

-- Direction mapping: hjkl keys to resize commands
-- h/l = horizontal edge detection -> vertical resize (change width)
-- j/k = vertical edge detection -> horizontal resize (change height)
local resize_config = {
	h = "vertical resize",
	j = "resize",
	k = "resize",
	l = "vertical resize",
}

local function smart_resize(dir)
	-- Skip floating windows
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		return
	end
	-- Skip single window (no-op anyway, but explicit)
	if vim.fn.winnr("$") == 1 then
		return
	end
	local count = vim.v.count1 -- Supports count prefix (defaults to 1)
	local step = get_resize_step() * count
	local cmd = resize_config[dir]
	local sign = at_edge(dir) and "-" or "+"
	pcall(vim.cmd, cmd .. " " .. sign .. step)
end

-- Normal mode
vim.keymap.set("n", "<M-h>", function()
	smart_resize("h")
end, { desc = "Smart resize left", silent = true })
vim.keymap.set("n", "<M-j>", function()
	smart_resize("j")
end, { desc = "Smart resize down", silent = true })
vim.keymap.set("n", "<M-k>", function()
	smart_resize("k")
end, { desc = "Smart resize up", silent = true })
vim.keymap.set("n", "<M-l>", function()
	smart_resize("l")
end, { desc = "Smart resize right", silent = true })

-- Terminal mode (exit to normal first using <C-\><C-n> pattern)
-- Set vim.g.smart_resize_terminal_stay_normal = true to stay in normal mode after resize
local function terminal_smart_resize(dir)
	return function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
		vim.schedule(function()
			if vim.fn.mode() ~= "n" then
				return
			end
			smart_resize(dir)
			-- Return to terminal insert mode unless configured otherwise
			if not vim.g.smart_resize_terminal_stay_normal then
				vim.cmd("startinsert")
			end
		end)
	end
end

vim.keymap.set("t", "<M-h>", terminal_smart_resize("h"), { desc = "Smart resize left", silent = true })
vim.keymap.set("t", "<M-j>", terminal_smart_resize("j"), { desc = "Smart resize down", silent = true })
vim.keymap.set("t", "<M-k>", terminal_smart_resize("k"), { desc = "Smart resize up", silent = true })
vim.keymap.set("t", "<M-l>", terminal_smart_resize("l"), { desc = "Smart resize right", silent = true })
