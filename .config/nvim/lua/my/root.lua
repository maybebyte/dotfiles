-- Project root detection module
-- API: require("my.root").get(bufnr?) -> absolute path string
-- Algorithm:
--   1. Collect covering LSP workspaces and the nearest `.git` ancestor
--   2. Prefer the most specific candidate
--   3. Fallback to vim.fn.getcwd()
-- Unnamed buffers try a .git walk from cwd before surrendering.
-- Cache: vim.b[bufnr].my_root, invalidated on BufFilePost.

local M = {}

-- Canonicalize the longest existing prefix so new files under symlinked
-- directories stay comparable with resolved workspace roots.
local function resolve(path)
	if not path then
		return nil
	end

	local missing = {}
	local current = path
	while current do
		local resolved = vim.uv.fs_realpath(current)
		if resolved then
			for index = #missing, 1, -1 do
				resolved = vim.fs.joinpath(resolved, missing[index])
			end
			return resolved
		end

		local parent = vim.fs.dirname(current)
		if not parent or parent == current then
			break
		end
		missing[#missing + 1] = vim.fs.basename(current)
		current = parent
	end

	return path
end

local function buffer_path(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return nil
	end
	return resolve(name)
end

local function prefer_narrower(best, candidate)
	if not candidate then
		return best
	end
	if not best or #candidate > #best or (#candidate == #best and candidate < best) then
		return candidate
	end
	return best
end

-- LSP workspace_folders lookup. Returns nil if no folder covers the buffer.
-- The most specific covering folder wins, independent of client order.
local function lsp_root(bufnr, buf_path)
	if not buf_path then
		return nil
	end
	local best_prefix
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		local folders = client.workspace_folders
		if folders then
			for _, folder in ipairs(folders) do
				-- URI is "file:///..." — decode before compare.
				local fname = vim.uri_to_fname(folder.uri)
				local fresolved = resolve(fname)
				if fresolved and vim.fs.relpath(fresolved, buf_path) then
					best_prefix = prefer_narrower(best_prefix, fresolved)
				end
			end
		end
	end
	return best_prefix
end

function M.get(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Cache hit.
	local cached = vim.b[bufnr].my_root
	if cached and cached ~= "" then
		return cached
	end

	local buf_path = buffer_path(bufnr)

	-- Unnamed buffer: try .git root from cwd before surrendering.
	-- No cache write — buffer may receive a name later; next call re-resolves.
	if not buf_path then
		local cwd = vim.fn.getcwd()
		return resolve(vim.fs.root(cwd, { ".git" })) or cwd
	end

	-- Rank covering LSP workspaces against the nearest Git ancestor. This keeps
	-- narrow language-server roots while rejecting broad workspace folders.
	local root = lsp_root(bufnr, buf_path)
	root = prefer_narrower(root, resolve(vim.fs.root(bufnr, { ".git" })))

	-- Fallback to getcwd().
	if not root then
		root = vim.fn.getcwd()
	end

	vim.b[bufnr].my_root = root
	return root
end

-- Cache invalidation on buffer rename.
vim.api.nvim_create_autocmd("BufFilePost", {
	group = vim.api.nvim_create_augroup("my_root_cache", { clear = true }),
	callback = function(args)
		vim.b[args.buf].my_root = nil
	end,
})

return M
