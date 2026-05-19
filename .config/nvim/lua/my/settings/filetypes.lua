-- luacheck: globals vim

-- Filetype overrides. Loaded eagerly via `lua/my/settings/init.lua` so
-- detection is in place before the first buffer is read.

-- `.tf` files: Neovim's builtin detect.tf inspects content and falls back to
-- the legacy `tf` filetype on empty / comment-only buffers, which prevents
-- terraform-ls from attaching to fresh files. Force `terraform` unconditionally
-- (the `.tfvars` → `terraform-vars` mapping is unaffected and stays builtin).
vim.filetype.add({
	extension = {
		tf = "terraform",
	},
})
