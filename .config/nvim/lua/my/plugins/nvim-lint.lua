-- luacheck: globals vim

return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = "BufReadPost", -- D-19: load before BufReadPost fires so LINT-01 (lint-on-open) works
	config = function()
		require("lint").linters_by_ft = {
			go = { "revive" },
			lua = { "luacheck", "selene" },
			html = { "erb_lint" },
			markdown = { "markdownlint" },
			python = { "mypy", "pylint", "ruff" },
		}

		-- NOTE: by default, erb_lint cmd and args are expecting a
		-- Gemfile (bundle exec), but mason.nvim doesn't create one
		--
		-- Unsure whether to mention this to
		-- https://github.com/williamboman/mason.nvim/issues
		require("lint").linters.erb_lint.cmd = "erblint"
		require("lint").linters.erb_lint.args = { "--format", "compact" }

		-- D-16..D-18: per-buffer debounced try_lint (150ms).
		-- Diverges from LazyVim util/lint.lua shared-timer pattern so saves in
		-- buffer A do not cancel pending lint for buffer B (ROADMAP SC-6).
		-- RESEARCH Pitfall 7: wrap try_lint in nvim_buf_call(bufnr, ...) so ft
		-- resolves against the originally-scheduled buffer, not whichever is
		-- current when the timer fires.
		-- Note: timers are uv userdata (not msgpack-serializable), so they live
		-- in a closure-local table keyed by bufnr — vim.b[bufnr] rejects userdata.
		local timers = {}
		local function debounced_lint(bufnr)
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			local prev = timers[bufnr]
			if prev then
				pcall(function()
					prev:stop()
					prev:close()
				end)
			end
			local timer = vim.uv.new_timer()
			timers[bufnr] = timer
			timer:start(
				150,
				0,
				vim.schedule_wrap(function()
					-- UTILS-05/D-20: suppress lint while any float is open (LSP hover,
					-- telescope, which-key, Snacks, cmp). Dropped silently (D-21) — next
					-- UserLint trigger (BufWritePost/InsertLeave/FileType/BufReadPost)
					-- catches up.
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(win).relative ~= "" then
							pcall(function()
								timer:stop()
								timer:close()
							end)
							timers[bufnr] = nil
							return
						end
					end
					if vim.api.nvim_buf_is_valid(bufnr) then
						vim.api.nvim_buf_call(bufnr, function()
							require("lint").try_lint()
						end)
					end
					pcall(function()
						timer:stop()
						timer:close()
					end)
					timers[bufnr] = nil
				end)
			)
		end

		-- Clean up per-buffer timer on buffer wipeout so timers[] doesn't grow
		-- unbounded over a long session.
		vim.api.nvim_create_autocmd("BufWipeout", {
			callback = function(args)
				local t = timers[args.buf]
				if t then
					pcall(function()
						t:stop()
						t:close()
					end)
					timers[args.buf] = nil
				end
			end,
		})

		-- D-22: single UserLint augroup owns all four lint triggers.
		-- No `pattern =` filter: try_lint() filters by ft internally
		-- (LINT-03 extends InsertLeave beyond lua via this mechanism).
		local lint_augroup = vim.api.nvim_create_augroup("UserLint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufReadPost", "FileType", "InsertLeave", "BufWritePost" }, {
			group = lint_augroup,
			callback = function(args)
				debounced_lint(args.buf)
			end,
		})
	end,
}
