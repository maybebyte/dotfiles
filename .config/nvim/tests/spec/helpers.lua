-- tests/spec/helpers.lua — Phase 5 test helper API
-- Consumers: every spec under tests/spec/*_spec.lua
-- Decisions: D-20..D-26 (nvim_child), D-33..D-40 (helper contracts)
-- DO NOT add before_each/after_each templates (D-40); compose in each spec.

local M = {}

-- ============================================================
-- M.assert_contains(haystack, needle)  — D-33
--   Plain string.find (NOT regex; pass plain=true). Errors with informative
--   message including both strings (truncated to 200 chars) on miss.
--   ASVS L1 V5: validates input types before use.
-- ============================================================
function M.assert_contains(haystack, needle)
	assert(type(haystack) == "string", "assert_contains: haystack must be string")
	assert(type(needle) == "string", "assert_contains: needle must be string")
	if not haystack:find(needle, 1, true) then
		error(
			string.format(
				"assert_contains: %q not found in %q",
				needle:sub(1, 200),
				haystack:sub(1, 200)
			),
			2
		)
	end
end

-- ============================================================
-- M.assert_no_lua_error(r)  — D-17 (Phase 7 carve-out from Phase 6 D-13)
--   Accepts H.nvim_child result table {exit, stdout, stderr}.
--   Concatenates stdout + "\n" + stderr; runs plain-find sniff for known
--   Lua-error markers (E5108, stack traceback, attempt to call/index).
--   Errors with truncated (~200-char) combined output on match. Level=2
--   (blame caller, not helper).
--   Justification: headless nvim does NOT abort on `-c lua` errors, so a
--   regression in LspAttach could emit a traceback but still exit 0 with
--   "false"/"nil" as the last line, masking the real cause. Mirrors bash
--   defense-in-depth (inlay-hints-attach.sh L86-90, cap-guard.sh L46-50).
-- ============================================================
function M.assert_no_lua_error(r)
	assert(type(r) == "table", "assert_no_lua_error: r must be table")
	local combined = (r.stdout or "") .. "\n" .. (r.stderr or "")
	local needles = { "E5108", "stack traceback", "attempt to call", "attempt to index" }
	for _, needle in ipairs(needles) do
		if combined:find(needle, 1, true) then
			error(
				string.format(
					"assert_no_lua_error: matched %q in subprocess output:\n%s",
					needle,
					combined:sub(1, 200)
				),
				2
			)
		end
	end
end

-- ============================================================
-- M.wait_for(cond, timeout_ms)  — D-38
--   Wrapper around vim.wait with 50ms interval. Returns boolean
--   (true = cond satisfied within timeout, false = timeout).
-- ============================================================
function M.wait_for(cond, timeout_ms)
	return vim.wait(timeout_ms or 1000, cond, 50)
end

-- ============================================================
-- M.force_very_lazy()  — D-37
--   In-process equivalent of `:doautocmd User VeryLazy`.
--   modeline = false avoids re-running modelines on the current buffer
--   (security; matches project's intentional modeline disable).
-- ============================================================
function M.force_very_lazy()
	vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy", modeline = false })
end

-- ============================================================
-- M.with_temp_file(content, fn)  — D-35
--   Writes content to vim.fn.tempname(), calls fn(path), always deletes
--   the file even when fn errors (pcall-cleanup-rethrow).
--   ASVS L1 V8 cleanup-on-error, V12 vim.fn.tempname + vim.fn.delete.
-- ============================================================
function M.with_temp_file(content, fn)
	local path = vim.fn.tempname()
	local fh = assert(io.open(path, "w"), "with_temp_file: cannot open " .. path)
	fh:write(content or "")
	fh:close()
	local ok, err = pcall(fn, path)
	vim.fn.delete(path)
	if not ok then
		error(err, 2)
	end
end

-- ============================================================
-- M.tmp_git_dir(fn)  — D-35
--   Creates a temp directory, runs `git init -q` inside, calls fn(path),
--   then always rm -rf the directory. Cleanup-on-error.
--   Uses vim.fn.system array form (no shell expansion → no injection),
--   path comes from vim.fn.tempname() (not user-controlled). ASVS L1 V5.
-- ============================================================
function M.tmp_git_dir(fn)
	local dir = vim.fn.tempname()
	vim.fn.mkdir(dir, "p")
	vim.fn.system({ "git", "-C", dir, "init", "-q" })
	local ok, err = pcall(fn, dir)
	vim.fn.delete(dir, "rf")
	if not ok then
		error(err, 2)
	end
end

-- ============================================================
-- M.notify_stub()  — D-36
--   Returns { calls = {}, restore = function(self) end }.
--   Stashes original vim.notify in closure; replaces with capturing fn.
--   Caller is responsible for invoking :restore() (typically in after_each)
--   per D-09 trust-boundary note in PLAN's threat register (T-5-09).
-- ============================================================
function M.notify_stub()
	local original = vim.notify
	local stub = { calls = {} }
	vim.notify = function(msg, level, opts)
		table.insert(stub.calls, { msg = msg, level = level, opts = opts })
	end
	function stub:restore()
		vim.notify = original
	end
	return stub
end

-- ============================================================
-- M.with_fresh_module(mod, fn)  — D-39
--   Clears package.loaded[mod], requires it fresh, calls fn(mod),
--   clears again on exit. Side-effect cleanup (autocmds, keymaps) is
--   the caller's responsibility — the project's `clear = true` augroup
--   convention (CLAUDE.md) makes most re-requires naturally safe.
-- ============================================================
function M.with_fresh_module(mod, fn)
	package.loaded[mod] = nil
	local m = require(mod)
	local ok, err = pcall(fn, m)
	package.loaded[mod] = nil
	if not ok then
		error(err, 2)
	end
end

-- ============================================================
-- M.nvim_child(opts)  — D-20..D-26
--   Spawns a headless nvim subprocess.
--     opts.args:    extra cmd args appended after `--headless`
--                   (default {} → child boots full user config, D-21).
--     opts.timeout: ms (default 5000, D-24). PORT-13 (gopls/inlayhints)
--                   should override to 10000-15000.
--   Env whitelist: { HOME, PATH, TERM } (D-20). NVIM_APPNAME left at
--   default (parent's) so the child finds ~/.config/nvim/init.lua.
--   Return: { exit = N, stdout = "...", stderr = "..." } (D-23).
--   On timeout: jobstop + exit=-1 + stderr suffix (D-26). No --listen (D-25).
--   Threat T-5-06 (env leak) mitigated via clear_env=true + 3-key whitelist.
--   Threat T-5-08 (hang) mitigated via timeout + jobstop.
-- ============================================================
function M.nvim_child(opts)
	opts = opts or {}
	local timeout = opts.timeout or 5000
	local args = opts.args or {}
	local cmd = { "nvim", "--headless" }
	for _, a in ipairs(args) do
		table.insert(cmd, a)
	end

	local stdout_chunks, stderr_chunks = {}, {}
	local id = vim.fn.jobstart(cmd, {
		env = {
			HOME = vim.env.HOME,
			PATH = vim.env.PATH,
			TERM = vim.env.TERM or "dumb",
		},
		clear_env = true,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			for _, l in ipairs(data) do
				table.insert(stdout_chunks, l)
			end
		end,
		on_stderr = function(_, data)
			for _, l in ipairs(data) do
				table.insert(stderr_chunks, l)
			end
		end,
	})
	if id <= 0 then
		error("nvim_child: jobstart failed (id=" .. id .. ")", 2)
	end

	local result = vim.fn.jobwait({ id }, timeout)
	local exit = result[1]
	local stdout = table.concat(stdout_chunks, "\n")
	local stderr = table.concat(stderr_chunks, "\n")
	if exit == -1 then
		vim.fn.jobstop(id)
		stderr = stderr .. "\n[H.nvim_child] timed out after " .. timeout .. "ms"
	end
	return { exit = exit, stdout = stdout, stderr = stderr }
end

return M
