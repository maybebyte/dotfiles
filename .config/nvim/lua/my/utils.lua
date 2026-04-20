-- Shared utility module
-- Consumers:
--   - lua/my/plugins/gitsigns.lua, vim-fugitive.lua, vim-rhubarb.lua (is_git_repo cond)
--   - lua/my/keybindings/init.lua (resize / diagnostic helpers — added in plan 04-02)
local M = {}

-- Return true when the current working directory is inside a git repo,
-- including bare repos and worktrees that have no literal `.git` directory.
-- Preserves the OR semantics from the original gitsigns/fugitive/rhubarb cond.
function M.is_git_repo()
	return vim.fn.isdirectory(".git") == 1
		or vim.trim(vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")) == "true"
end

return M
