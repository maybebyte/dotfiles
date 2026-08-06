-- luacheck: globals vim

-- Parsers to install. `markdown_inline`, `jinja_inline`, `ecma`, `jsx`,
-- and `html_tags` arrive implicitly as declared `requires` of entries
-- below, so they are not listed here.
local languages = {
	"bash",
	"c",
	"css",
	"diff",
	"gitcommit",
	"go",
	"hcl",
	"html",
	"javascript",
	"jinja",
	"latex",
	"lua",
	"make",
	"markdown",
	"nix",
	"python",
	"query",
	"terraform",
	"vim",
	"vimdoc",
	"yaml",
}

-- Text objects, ported from the `master` branch's declarative tables.
-- 24 mappings: 6 select, 12 move, 6 swap.
local select_maps = {
	{ "aa", "@parameter.outer", "Select outer parameter" },
	{ "ia", "@parameter.inner", "Select inner parameter" },
	{ "af", "@function.outer", "Select outer function" },
	{ "if", "@function.inner", "Select inner function" },
	{ "ac", "@class.outer", "Select outer class" },
	{ "ic", "@class.inner", "Select inner class" },
}

local move_maps = {
	goto_next_start = {
		{ "]a", "@parameter.inner", "Next parameter start" },
		{ "]m", "@function.outer", "Next function start" },
		{ "]]", "@class.outer", "Next class start" },
	},
	goto_next_end = {
		{ "]A", "@parameter.inner", "Next parameter end" },
		{ "]M", "@function.outer", "Next function end" },
		{ "][", "@class.outer", "Next class end" },
	},
	goto_previous_start = {
		{ "[a", "@parameter.inner", "Previous parameter start" },
		{ "[m", "@function.outer", "Previous function start" },
		{ "[[", "@class.outer", "Previous class start" },
	},
	goto_previous_end = {
		{ "[A", "@parameter.inner", "Previous parameter end" },
		{ "[M", "@function.outer", "Previous function end" },
		{ "[]", "@class.outer", "Previous class end" },
	},
}

local swap_maps = {
	swap_next = {
		{ "<leader>lp", "@parameter.inner", "Swap next parameter" },
		{ "<leader>jf", "@function.outer", "Swap next function" },
		{ "<leader>jc", "@class.outer", "Swap next class" },
	},
	swap_previous = {
		{ "<leader>hp", "@parameter.inner", "Swap previous parameter" },
		{ "<leader>kf", "@function.outer", "Swap previous function" },
		{ "<leader>kc", "@class.outer", "Swap previous class" },
	},
}

-- Marks a buffer as carrying *this config's* text object maps. Master
-- tracked the equivalent in `attached_buffers_by_module` and gated
-- detach on it. Without a stand-in, `detach_textobjects` cannot tell our
-- `]]` from the one `$VIMRUNTIME/ftplugin/ruby.vim` just installed, and
-- deletes both. Stored on the buffer so it dies with it.
local ATTACHED = "my_treesitter_textobjects"

-- Buffer-local, matching what master's `attach.lua` did. The `require`
-- calls sit inside the callbacks, so defining a mapping never forces a
-- plugin load.
local function attach_textobjects(bufnr)
	local base = { buffer = bufnr, silent = true, remap = false }

	local function map(mode, lhs, desc, fn)
		vim.keymap.set(mode, lhs, fn, vim.tbl_extend("force", base, { desc = desc }))
	end

	for _, entry in ipairs(select_maps) do
		local lhs, query, desc = entry[1], entry[2], entry[3]
		map({ "x", "o" }, lhs, desc, function()
			require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
		end)
	end

	for fn_name, entries in pairs(move_maps) do
		for _, entry in ipairs(entries) do
			local lhs, query, desc = entry[1], entry[2], entry[3]
			map({ "n", "x", "o" }, lhs, desc, function()
				require("nvim-treesitter-textobjects.move")[fn_name](query, "textobjects")
			end)
		end
	end

	for fn_name, entries in pairs(swap_maps) do
		for _, entry in ipairs(entries) do
			local lhs, query, desc = entry[1], entry[2], entry[3]
			map("n", lhs, desc, function()
				require("nvim-treesitter-textobjects.swap")[fn_name](query)
			end)
		end
	end

	vim.b[bufnr][ATTACHED] = true
end

-- Master's FileType handler ran detach-then-attach (`reattach_module`).
-- Attaching only is not equivalent: when a buffer's filetype changes to
-- one without a parser, the stale buffer-local maps survive, and the 12
-- move maps then raise E5108 -- including `]]`, `[[`, `]m`, `[m`, which
-- shadow builtin motions.
--
-- Three things here are load-bearing, and dropping any reintroduces a
-- silent regression:
--
--  1. The `ATTACHED` gate. This runs on *every* FileType event, and
--     `MyTreesitterTextobjects` is ordered after `$VIMRUNTIME/ftplugin`.
--     Ungated, it deletes the ftplugin's own `]] [[ ]m [m ]M [M ][ []`
--     from every buffer we never attached to -- ruby, rust, sql, help,
--     checkhealth -- and nothing restores them, because `b:did_ftplugin`
--     is already set.
--  2. One mode per `pcall`. `vim.keymap.del` loops modes internally with
--     no per-mode guard, so a batched `del({"n","x","o"}, ...)` aborts on
--     the first mode that is already gone and a single outer `pcall`
--     swallows it. `b:undo_ftplugin` for markdown and vim unmaps these in
--     `n` and `x` before we run, which left the `o` maps alive -- exactly
--     the E5108 this function exists to prevent.
--  3. The per-map `desc` ownership check. The gate cannot help a buffer
--     we *did* attach to: when its filetype changes, `filetypeplugin`
--     has already sourced the new ftplugin by the time this runs, so
--     `]]` may already be that ftplugin's replacement, not ours.
--     Deleting by bare lhs then destroys the map that was just
--     installed (python -> ruby lost ruby's `]]`/`]m` searchsyn
--     motions), again with nothing to restore it.
local function detach_textobjects(bufnr)
	if not vim.b[bufnr][ATTACHED] then
		return
	end

	local function del(modes, lhs, desc)
		if type(modes) == "string" then
			modes = { modes }
		end

		for _, mode in ipairs(modes) do
			local map = vim.api.nvim_buf_call(bufnr, function()
				return vim.fn.maparg(lhs, mode, false, true)
			end)

			if map.buffer == 1 and map.desc == desc then
				pcall(vim.keymap.del, mode, lhs, { buffer = bufnr })
			end
		end
	end

	for _, entry in ipairs(select_maps) do
		del({ "x", "o" }, entry[1], entry[3])
	end

	for _, entries in pairs(move_maps) do
		for _, entry in ipairs(entries) do
			del({ "n", "x", "o" }, entry[1], entry[3])
		end
	end

	for _, entries in pairs(swap_maps) do
		for _, entry in ipairs(entries) do
			del("n", entry[1], entry[3])
		end
	end

	vim.b[bufnr][ATTACHED] = nil
end

-- Languages where `main` ships an `indents.scm` that `master` did not.
-- Master gated indent on `has_indents`, so these silently gain
-- treesitter indent on migration -- a behavior change, not a port.
-- `bash` is the only divergence across the original parser set: its
-- treesitter indent flattens backslash and pipeline continuations to
-- column 0, where `GetShIndent()` indents them. Remove an entry here to
-- adopt the treesitter indent for that language.
local indent_optout = {
	bash = true,
}

local TS_INDENTEXPR = "v:lua.require'nvim-treesitter'.indentexpr()"

-- Records the language we called `vim.treesitter.start()` with, so the
-- next `FileType` event can tear it down again. Master got this from
-- `reattach_module` (detach + attach); starting only leaves the previous
-- filetype's parser painting the buffer with `'syntax'` pinned to `''`.
local STARTED = "my_treesitter_lang"

-- Holds the `'indentexpr'` that was in effect before we overwrote it.
local INDENT_SAVED = "my_treesitter_indentexpr"

-- Undoes our `'indentexpr'`, but only if it is still ours. By the time
-- this runs, the new filetype's `indent/<ft>.vim` has already fired --
-- if it set its own expression, that one is correct and must win.
-- Restoring blindly here would clobber it.
--
-- Neovim only clears `'indentexpr'` for us when the old filetype set
-- `b:undo_indent` or the new one ships an indent script. markdown and
-- nix ship `indents.scm` but no runtime indent script, so without this
-- they leak the treesitter expression into text/help/conf buffers.
local function restore_indentexpr(bufnr)
	local saved = vim.b[bufnr][INDENT_SAVED]
	if saved == nil then
		return
	end

	vim.b[bufnr][INDENT_SAVED] = nil

	if vim.bo[bufnr].indentexpr == TS_INDENTEXPR then
		vim.bo[bufnr].indentexpr = saved
	end
end

-- Resolves a filetype to a language whose parser is actually
-- installed, or nil.
--
-- Order matters. `language.add()` returns nil + err when no parser
-- file exists, but *raises* when one exists and fails to load -- a
-- truncated .so from an interrupted :TSUpdate, or a stale parser after
-- a Neovim upgrade bumps the ABI floor -- so it needs a `pcall` on top
-- of the return-value guard, or one corrupt parser turns every
-- FileType event for that filetype into an autocmd error instead of
-- the `:syntax` fallback. `query.get()` also asserts ("No parser for
-- language ..."), so no caller may reach it until `add()` has
-- confirmed the parser loads.
local function resolve_lang(filetype)
	if filetype == nil or filetype == "" then
		return nil
	end

	local lang = vim.treesitter.language.get_lang(filetype)
	if not lang then
		return nil
	end

	local ok, has_parser = pcall(vim.treesitter.language.add, lang)
	if not ok or not has_parser then
		return nil
	end

	return lang
end

-- `query.get()` raises when a query file names a node the installed
-- parser does not produce. That skew is one failed `:TSUpdate` away:
-- `site/queries/<lang>` are symlinks into the plugin checkout, while
-- `site/parser/<lang>.so` stays at the last successful build, so a
-- plugin update whose build step fails leaves new queries over old
-- parsers. The raise is not memoized (only successful returns are
-- cached), so unguarded it repeats on every FileType event instead
-- of degrading to `:syntax`.
local function get_query(lang, name)
	local ok, query = pcall(vim.treesitter.query.get, lang, name)
	return ok and query or nil
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		"nvim-treesitter/nvim-treesitter-context",
	},
	lazy = true,
	event = "FileType",
	-- `main` defines its commands in `plugin/nvim-treesitter.lua`, which
	-- only runs on plugin load. Without these stubs, a session that never
	-- fires FileType (bare `nvim`, unrecognized extensions) has no
	-- :TSUpdate -- the manual update path README.md tells you to run.
	cmd = { "TSInstall", "TSInstallFromGrammar", "TSUpdate", "TSUninstall", "TSLog" },
	build = ":TSUpdate",

	-- Highlighting and indent are pure `vim.treesitter` calls, so this
	-- autocmd works before the plugin is loaded.
	init = function()
		-- `language.get_lang()` falls back to the filetype name itself
		-- for anything unmapped. Main ships these aliases in
		-- `plugin/filetypes.lua`, but that only runs once the plugin
		-- loads; registering here removes the ordering dependency.
		vim.treesitter.language.register("terraform", "terraform-vars")
		vim.treesitter.language.register("latex", "tex")
		vim.treesitter.language.register("bash", "sh")

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("MyTreesitter", { clear = true }),
			desc = "Start treesitter highlighting and indent",
			callback = function(ev)
				local lang = resolve_lang(ev.match)
				local started = vim.b[ev.buf][STARTED]

				-- Tear down the previous filetype's highlighting.
				-- `stop()` restores `'spelloptions'`, clears
				-- `b:ts_highlight` and re-fires the `syntaxset` autocmd,
				-- handing the buffer back to `:syntax`. Skipped when the
				-- language is unchanged and the highlighter is still
				-- live, so a re-fired FileType does not rebuild it.
				-- `ts_highlight` is the liveness check because some
				-- ftplugins call `stop()` from `b:undo_ftplugin`.
				if started and (started ~= lang or not vim.b[ev.buf].ts_highlight) then
					vim.treesitter.stop(ev.buf)
					started = nil
					vim.b[ev.buf][STARTED] = nil
				end

				restore_indentexpr(ev.buf)

				if not lang then
					return
				end

				if not started then
					-- `$VIMRUNTIME/ftplugin` for lua, markdown, help,
					-- and query calls `start()` itself, and
					-- `filetypeplugin` runs before this autocmd (so
					-- does snacks.quickfile). Starting on top of that
					-- stacks a second highlighter: `TSHighlighter.new`
					-- overwrites `active[buf]` but never destroys the
					-- first one -- its tree callbacks stay registered
					-- for the buffer's lifetime -- and it snapshots
					-- `'spelloptions'` *after* the first start already
					-- appended `noplainbuffer`, so every later
					-- teardown restores the polluted value. Adopting
					-- the live highlighter keeps it single and hands
					-- it to our teardown; setting STARTED also gates
					-- off the post-install FileType replay.
					if vim.b[ev.buf].ts_highlight then
						vim.b[ev.buf][STARTED] = lang
					else
						-- The highlights gate covers a state install()
						-- cannot repair: a kill between the parser `.so`
						-- landing and the query symlinks leaves a parser
						-- without queries, and `get_installed()` (a union
						-- of both directories) reports it installed
						-- forever. `highlighter.new` pins `'syntax'` to
						-- `''` even when no highlights query resolves, so
						-- starting anyway strips legacy syntax and sets
						-- STARTED -- which also gates off the post-install
						-- FileType replay. No query, no start.
						--
						-- The pcall is the same skew guard as `get_query`:
						-- `start()` re-raises a broken `highlights.scm`
						-- out of `TSHighlighter:get_query` after cleanup.
						-- On failure the buffer keeps `:syntax`.
						if get_query(lang, "highlights") and pcall(vim.treesitter.start, ev.buf, lang) then
							vim.b[ev.buf][STARTED] = lang
						end
					end
				end

				-- Reproduces master's `is_supported = has_indents`.
				-- Without this, ungated indentexpr silently replaces
				-- the built-in indent script with a no-op.
				if not indent_optout[lang] and get_query(lang, "indents") then
					vim.b[ev.buf][INDENT_SAVED] = vim.bo[ev.buf].indentexpr
					vim.bo[ev.buf].indentexpr = TS_INDENTEXPR
				end
			end,
		})
	end,

	config = function()
		-- Every parser build shells out: `curl`+`tar` fetch the
		-- grammar tarball (no git fallback on `main`) and the
		-- `tree-sitter` CLI compiles it. mason-tool-installer
		-- provisions none of them, and on Qubes an AppVM install
		-- vanishes on reboot unless it lives in the template. A
		-- missing tool otherwise surfaces only as transient async
		-- echoes, then a silent `:syntax` fallback.
		local missing = vim.tbl_filter(function(tool)
			return vim.fn.executable(tool) == 0
		end, { "tree-sitter", "curl", "tar" })

		if #missing > 0 then
			vim.notify(
				"nvim-treesitter: missing parser build tools: "
					.. table.concat(missing, ", ")
					.. " -- builds will fail (see README Dependencies)",
				vim.log.levels.WARN
			)
		end

		-- `install` is asynchronous, and `main` -- unlike master's
		-- `reattach_if_possible_fn` -- has no post-install hook. Without
		-- this, buffers already open when a parser finishes building
		-- stay unhighlighted until they are reopened.
		--
		-- The task resolves on every startup, not only when something was
		-- built, so the re-broadcast is gated per buffer: replay `FileType`
		-- only where we never started treesitter *and* a parser now
		-- resolves -- i.e. exactly the buffers a build just unblocked. An
		-- ungated `doautocmd` here replays the whole FileType chain
		-- (ftplugins, lspconfig, nvim-lint) for every buffer on every
		-- launch, which the parent never did.
		require("nvim-treesitter").install(languages):await(function()
			vim.schedule(function()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(bufnr) and not vim.b[bufnr][STARTED] then
						local filetype = vim.bo[bufnr].filetype
						if filetype ~= "" and resolve_lang(filetype) then
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd("doautocmd FileType " .. filetype)
							end)
						end
					end
				end
			end)
		end)

		require("nvim-treesitter-textobjects").setup({
			select = { lookahead = true },
			move = { set_jumps = true },
		})

		-- Registered here, not in `init`: the textobjects queries only
		-- land on 'runtimepath' once that plugin is loaded, so an
		-- init-time `query.get` would find nothing and silently drop
		-- all 24 mappings. This mirrors master's `configs.lua`.
		local group = vim.api.nvim_create_augroup("MyTreesitterTextobjects", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			desc = "Attach treesitter text objects",
			callback = function(ev)
				detach_textobjects(ev.buf)

				local lang = resolve_lang(ev.match)
				if lang and get_query(lang, "textobjects") then
					attach_textobjects(ev.buf)
				end
			end,
		})

		-- The buffer that triggered this load already fired FileType
		-- before the autocmd above existed.
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local lang = resolve_lang(vim.bo[bufnr].filetype)
				if lang and get_query(lang, "textobjects") then
					attach_textobjects(bufnr)
				end
			end
		end
	end,
}
