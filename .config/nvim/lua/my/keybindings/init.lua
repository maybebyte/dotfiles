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
vim.keymap.set("t", "<C-Space>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Exit terminal + move left" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Exit terminal + move down" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Exit terminal + move up" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Exit terminal + move right" })
