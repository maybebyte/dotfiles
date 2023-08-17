-- luacheck: globals vim

vim.keymap.set({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to CLIPBOARD." })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy lines to CLIPBOARD." })

vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from CLIPBOARD (after cursor)." })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from CLIPBOARD (before cursor)." })

vim.keymap.set("", ";", ":", { desc = "Semicolon swapped with colon to protect pinky." })
vim.keymap.set("", ":", ";", { desc = "Colon swapped with semicolon to protect pinky." })

vim.keymap.set("n", "S", ":%s//g<Left><Left>", { desc = "Replace all." })

vim.keymap.set("n", "<leader>d", function()
	vim.api.nvim_put({ os.date("%F") }, "l", true, false)
end, { desc = "Insert current date." })

vim.keymap.set("n", "<leader>dtws", function()
	vim.cmd("%s/\\s\\+$//e")
end, { desc = "Delete all trailing whitespace." })

vim.keymap.set("n", "<leader>dtnl", function()
	vim.cmd("%s/\\n\\+\\%$//e")
end, { desc = "Delete all trailing newlines." })

vim.keymap.set("n", "<leader>o", function()
	-- There's probably a better way to do this in Lua, but I don't know it
	-- right now.
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

vim.keymap.set("n", "<leader>frm", function()
	vim.cmd.Format()
end, { desc = "Format files using formatter.nvim" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv", { desc = "Move selection down a line." })
vim.keymap.set("v", "K", ":m '<-2<CR>gv", { desc = "Move selection up a line." })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep cursor in the same place when joining lines." })
