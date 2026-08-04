-- luacheck: globals vim

return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = "BufReadPost", -- load before first BufReadPost so lint-on-open works
	config = function()
		require("lint").linters_by_ft = {
			go = { "revive" },
			lua = { "luacheck", "selene" },
			html = { "erb_lint" },
			markdown = { "markdownlint" },
			python = { "mypy", "pylint", "ruff" },
			terraform = { "tflint" },
		}

		-- NOTE: by default, erb_lint cmd and args are expecting a
		-- Gemfile (bundle exec), but mason.nvim doesn't create one
		--
		-- Unsure whether to mention this to
		-- https://github.com/williamboman/mason.nvim/issues
		local erb_lint = require("lint").linters.erb_lint
		local parse_erb_lint = erb_lint.parser
		erb_lint.cmd = "erblint"
		erb_lint.args = { "--format", "compact" }
		erb_lint.stream = "both"
		erb_lint.parser = function(output, bufnr, cwd)
			local diagnostics = parse_erb_lint(output, bufnr, cwd)

			-- erb_lint exits with code 1 for ordinary findings, so the exit code
			-- alone cannot distinguish findings from a Ruby runtime failure.
			for line in output:gmatch("[^\r\n]+") do
				-- A valid compact finding can end in an exception-like class name.
				if not line:match("^.+:%d+:%d+:%s") then
					local exception = line:match("%(([%w_:]*Error)%)%s*$")
						or line:match("%(([%w_:]*Exception)%)%s*$")
					if exception then
						local message = line:match(":%s+(.+)%s+%(" .. exception .. "%)%s*$")
						local details = message and message .. " (" .. exception .. ")" or line
						table.insert(diagnostics, {
							lnum = 0,
							col = 0,
							message = "erb_lint failed: " .. details,
							severity = vim.diagnostic.severity.ERROR,
							source = "erb-lint",
						})
						break
					end
				end
			end

			return diagnostics
		end

		-- Per-buffer debounced try_lint (150ms). Diverges from the LazyVim
		-- shared-timer pattern so saves in buffer A do not cancel pending lint
		-- for buffer B. try_lint is wrapped in nvim_buf_call(bufnr, ...) so ft
		-- resolves against the originally-scheduled buffer, not whichever is
		-- current when the timer fires. Timers are uv userdata (not
		-- msgpack-serializable), so they live in a closure-local table keyed
		-- by bufnr — vim.b[bufnr] rejects userdata.
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
					-- Suppress lint while any float is open (LSP hover, telescope,
					-- which-key, Snacks, cmp). Dropped silently — the next UserLint
					-- trigger (BufWritePost/InsertLeave/FileType/BufReadPost) catches up.
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

		-- Single UserLint augroup owns all four lint triggers.
		-- No `pattern =` filter: try_lint() filters by ft internally.
		local lint_augroup = vim.api.nvim_create_augroup("UserLint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufReadPost", "FileType", "InsertLeave", "BufWritePost" }, {
			group = lint_augroup,
			callback = function(args)
				debounced_lint(args.buf)
			end,
		})
	end,
}
