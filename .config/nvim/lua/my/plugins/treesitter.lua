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
end

-- Master's FileType handler ran detach-then-attach (`reattach_module`).
-- Attaching only is not equivalent: when a buffer's filetype changes to
-- one without a parser, the stale buffer-local maps survive, and the 12
-- move maps then raise E5108 -- including `]]`, `[[`, `]m`, `[m`, which
-- shadow builtin motions.
local function detach_textobjects(bufnr)
	local function del(mode, lhs)
		pcall(vim.keymap.del, mode, lhs, { buffer = bufnr })
	end

	for _, entry in ipairs(select_maps) do
		del({ "x", "o" }, entry[1])
	end

	for _, entries in pairs(move_maps) do
		for _, entry in ipairs(entries) do
			del({ "n", "x", "o" }, entry[1])
		end
	end

	for _, entries in pairs(swap_maps) do
		for _, entry in ipairs(entries) do
			del("n", entry[1])
		end
	end
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

-- Resolves a filetype to a language whose parser is actually
-- installed, or nil.
--
-- Order matters. `language.add()` returns nil + err rather than
-- raising, so it is guarded on its return value. `query.get()` is the
-- opposite -- it *asserts* ("No parser for language ...") -- so no
-- caller may reach it until `add()` has confirmed the parser exists.
local function resolve_lang(filetype)
	if filetype == nil or filetype == "" then
		return nil
	end

	local lang = vim.treesitter.language.get_lang(filetype)
	if not lang then
		return nil
	end

	if not vim.treesitter.language.add(lang) then
		return nil
	end

	return lang
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
				if not lang then
					return
				end

				vim.treesitter.start(ev.buf, lang)

				-- Reproduces master's `is_supported = has_indents`.
				-- Without this, ungated indentexpr silently replaces
				-- the built-in indent script with a no-op.
				if not indent_optout[lang] and vim.treesitter.query.get(lang, "indents") then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,

	config = function()
		-- `install` is asynchronous, and `main` -- unlike master's
		-- `reattach_if_possible_fn` -- has no post-install hook. Without
		-- this, buffers already open when a parser finishes building
		-- stay unhighlighted until they are reopened. Only reachable on
		-- a fresh machine or after adding a language.
		require("nvim-treesitter").install(languages):await(function()
			vim.schedule(function()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					local filetype = vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype or ""
					if filetype ~= "" then
						vim.api.nvim_buf_call(bufnr, function()
							vim.cmd("doautocmd FileType " .. filetype)
						end)
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
				if lang and vim.treesitter.query.get(lang, "textobjects") then
					attach_textobjects(ev.buf)
				end
			end,
		})

		-- The buffer that triggered this load already fired FileType
		-- before the autocmd above existed.
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local lang = resolve_lang(vim.bo[bufnr].filetype)
				if lang and vim.treesitter.query.get(lang, "textobjects") then
					attach_textobjects(bufnr)
				end
			end
		end
	end,
}
