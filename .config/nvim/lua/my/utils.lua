-- Shared utility module
-- Consumers:
--   - lua/my/plugins/gitsigns.lua, vim-fugitive.lua, vim-rhubarb.lua (is_git_repo cond)
--   - lua/my/keybindings/init.lua (resize / diagnostic helpers)
local M = {}

-- Internal: resize command lookup (not exported — used only by M.smart_resize).
local resize_config = {
	h = "vertical resize",
	j = "resize",
	k = "resize",
	l = "vertical resize",
}

-- Return true when the current working directory is inside a git repo,
-- including bare repos and worktrees that have no literal `.git` directory.
function M.is_git_repo()
	return vim.fn.isdirectory(".git") == 1
		or vim.trim(vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")) == "true"
end

-- Configurable resize step, defaults to 2. Override with vim.g.smart_resize_step.
function M.get_resize_step()
	return vim.g.smart_resize_step or 2
end

-- Return true when the current window is at the edge in direction dir ("h","j","k","l").
function M.at_edge(dir)
	return vim.fn.winnr() == vim.fn.winnr(dir)
end

-- Resize the current split toward/away from the edge in direction dir.
-- No-ops on floating windows and single-window layouts. Honors vim.v.count1.
function M.smart_resize(dir)
	-- Skip floating windows
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		return
	end
	-- Skip single window (no-op anyway, but explicit)
	if vim.fn.winnr("$") == 1 then
		return
	end
	local count = vim.v.count1
	local step = M.get_resize_step() * count
	local cmd = resize_config[dir]
	local sign = M.at_edge(dir) and "-" or "+"
	pcall(vim.cmd, cmd .. " " .. sign .. step)
end

-- Higher-order: return a terminal-mode callable that normalizes the mode,
-- calls smart_resize, then re-enters insert unless
-- vim.g.smart_resize_terminal_stay_normal is true.
function M.terminal_smart_resize(dir)
	return function()
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
		vim.schedule(function()
			if vim.fn.mode() ~= "n" then
				return
			end
			M.smart_resize(dir)
			if not vim.g.smart_resize_terminal_stay_normal then
				vim.cmd("startinsert")
			end
		end)
	end
end

-- Higher-order: return a callable that jumps to next/prev diagnostic.
-- severity is an optional string like "ERROR" keyed against vim.diagnostic.severity.
function M.diagnostic_goto(next, severity)
	return function()
		vim.diagnostic.jump({
			count = (next and 1 or -1) * vim.v.count1,
			severity = severity and vim.diagnostic.severity[severity] or nil,
			float = true,
		})
	end
end

return M
