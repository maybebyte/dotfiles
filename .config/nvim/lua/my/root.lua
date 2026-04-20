-- Project root detection module
-- API: require("my.root").get(bufnr?) -> absolute path string
-- Algorithm (per D-10):
--   1. LSP workspace_folders with longest-common-prefix tie-break (D-15)
--   2. Walk up for `.git` marker (D-09)
--   3. Fallback to vim.fn.getcwd() (D-17; unnamed buffers also try git_walk(cwd) first)
-- Cache: vim.b[bufnr].my_root, invalidated on BufFilePost (D-11).

local M = {}

local function buffer_path(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return nil
	end
	return vim.uv.fs_realpath(name) or name
end

-- LSP workspace_folders lookup. Returns nil if no folder covers the buffer.
-- Tie-break: longest common prefix of the buffer's realpath (D-15).
local function lsp_root(bufnr, buf_path)
	if not buf_path then
		return nil
	end
	local best_prefix
	local best_len = 0
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		local folders = client.config and client.config.workspace_folders
		if folders then
			for _, folder in ipairs(folders) do
				-- URI is "file:///..." — decode before compare (RESEARCH Risk §7).
				local fname = vim.uri_to_fname(folder.uri)
				local fresolved = vim.uv.fs_realpath(fname) or fname
				if vim.startswith(buf_path, fresolved) and #fresolved > best_len then
					best_prefix = fresolved
					best_len = #fresolved
				end
			end
		end
	end
	return best_prefix
end

local function resolve(path)
	return path and (vim.uv.fs_realpath(path) or path) or nil
end

function M.get(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Cache hit (D-11).
	local cached = vim.b[bufnr].my_root
	if cached and cached ~= "" then
		return cached
	end

	local buf_path = buffer_path(bufnr)

	-- Unnamed buffer: try .git root from cwd before surrendering (D-17, GAP-01).
	-- No cache write — buffer may receive a name later; next call re-resolves.
	if not buf_path then
		local cwd = vim.fn.getcwd()
		return resolve(vim.fs.root(cwd, { ".git" })) or cwd
	end

	-- 1. LSP workspace_folders.
	local root = lsp_root(bufnr, buf_path)

	-- 2. `.git` walk.
	if not root then
		root = resolve(vim.fs.root(bufnr, { ".git" }))
	end

	-- 3. Fallback to getcwd() (D-17).
	if not root then
		root = vim.fn.getcwd()
	end

	vim.b[bufnr].my_root = root
	return root
end

-- Cache invalidation on buffer rename (D-11).
vim.api.nvim_create_autocmd("BufFilePost", {
	group = vim.api.nvim_create_augroup("my_root_cache", { clear = true }),
	callback = function(args)
		vim.b[args.buf].my_root = nil
	end,
})

return M
