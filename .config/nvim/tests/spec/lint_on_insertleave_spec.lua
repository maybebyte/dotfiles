-- Parity: tests/startup/tests/lint-on-insertleave.sh — 1 assertion
-- Wave B: real python linter on synthesized InsertLeave.
-- A4: nvim_exec_autocmds replaces nvim_feedkeys (deterministic; nvim-lint
--     handler reads only args.buf — see RESEARCH Assumption A4). Bash uses
--     feedkeys to drive a real `i...<Esc>` flow, but the synthesized event is
--     semantically equivalent for the autocmd-handler-level test.
-- D-07/D-08: hard-fail on missing linter; no mocking.
-- Pitfall 4: 3000ms vim.wait cushion for cold-start.
-- Pitfall 6: bdelete after :edit to prevent buffer leak.
-- Deviation: same as PORT-09 — lazy once=true BufReadPost handlers consumed
-- before specs run; nvim-lint loaded explicitly via rtp prepend + require.

local H = require("tests.spec.helpers")

-- Ensure nvim-lint is on rtp so require("lint") resolves.
local lint_path = vim.fn.stdpath("data") .. "/lazy/nvim-lint"
vim.opt.rtp:prepend(lint_path)

describe("PORT-10 nvim-lint runs on InsertLeave (python ft)", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
		-- Load nvim-lint and register UserLint augroup (same pattern as PORT-09).
		-- clear=true makes re-registration idempotent.
		local lint = require("lint")
		if not lint.linters_by_ft or not lint.linters_by_ft.python then
			lint.linters_by_ft = { python = { "mypy", "pylint", "ruff" } }
		end
		local lint_augroup = vim.api.nvim_create_augroup("UserLint", { clear = true })
		vim.api.nvim_create_autocmd(
			{ "BufReadPost", "FileType", "InsertLeave", "BufWritePost" },
			{
				group = lint_augroup,
				callback = function(args)
					local bufnr = args.buf
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(bufnr) then
							vim.api.nvim_buf_call(bufnr, function()
								pcall(lint.try_lint)
							end)
						end
					end)
				end,
			}
		)
	end)

	it("InsertLeave triggers lint on python ft", function()
		local p = vim.fn.tempname() .. ".py"
		local fh = assert(io.open(p, "w"))
		fh:write("x = 1\n")
		fh:close()
		local ok, err = pcall(function()
			vim.cmd("edit " .. p)
			local b = vim.api.nvim_get_current_buf()
			vim.api.nvim_exec_autocmds("InsertLeave", { buffer = b })
			vim.wait(3000, function() return #vim.diagnostic.get(0) > 0 end)
			assert.is_true(#vim.diagnostic.get(0) > 0)  -- assertion #1
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(p)
		if not ok then
			error(err, 2)
		end
	end)
end)
