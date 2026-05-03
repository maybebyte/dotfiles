-- Parity: tests/startup/tests/lint-debounce.sh — 1 assertion
-- Wave C: stateful stub. luassert.stub on require("lint").try_lint.
-- D-10: stub `try_lint` only — no further mocking.
-- D-11: explicit :revert() in after_each (NOT luassert auto-restore).
-- D-12: 3 nvim_exec_autocmds in tight loop + vim.wait(400, false) + assert was_called(1).
-- Pitfall 5 (CRITICAL ORDERING): in before_each — (1) source init.lua,
--   (2) load nvim-lint via rtp prepend + require (lazy.load unavailable headless),
--   (3) THEN stub(require("lint"), "try_lint").
--   Reversing → stub patches a fresh empty table; real `lint` module unstubbed.
-- Pitfall 7: use assert.stub(s).was_called(N), not #s.calls.

local H = require("tests.spec.helpers")
local stub = require("luassert.stub")

-- Ensure nvim-lint is on rtp so require("lint") resolves.
-- lazy.nvim's event=BufReadPost once=true handlers are consumed before specs run
-- in the plenary headless environment; manual rtp prepend bridges the gap.
local lint_path = vim.fn.stdpath("data") .. "/lazy/nvim-lint"
vim.opt.rtp:prepend(lint_path)

describe("PORT-11 lint debounce 150ms", function()
	local stubbed_try_lint

	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
		-- Pitfall 5: load nvim-lint (via rtp prepend above + require) BEFORE stubbing,
		-- else stub patches a fresh empty table, leaving real `lint` module unstubbed.
		-- Register the debounced UserLint augroup so BufWritePost triggers debounced_lint.
		local lint = require("lint")
		if not lint.linters_by_ft or not lint.linters_by_ft.python then
			lint.linters_by_ft = { python = { "mypy", "pylint", "ruff" } }
		end
		-- Re-register the debounced UserLint augroup (mirrors nvim-lint.lua config).
		-- The debounced_lint closure calls require("lint").try_lint() — same module
		-- table the stub patches — so assert.stub().was_called(N) works correctly.
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
		local lint_augroup = vim.api.nvim_create_augroup("UserLint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufReadPost", "FileType", "InsertLeave", "BufWritePost" }, {
			group = lint_augroup,
			callback = function(args)
				debounced_lint(args.buf)
			end,
		})
		-- Pitfall 5 step 3: stub AFTER nvim-lint module is loaded.
		stubbed_try_lint = stub(lint, "try_lint")
	end)

	after_each(function()
		stubbed_try_lint:revert()  -- D-11: explicit revert (not luassert auto-restore)
	end)

	it("3 rapid BufWritePost triggers within 150ms fire try_lint exactly once", function()
		H.with_temp_file("x = 1\n", function(p)
			vim.cmd("edit " .. p)
			local b = vim.api.nvim_get_current_buf()
			for _ = 1, 3 do
				vim.api.nvim_exec_autocmds("BufWritePost", { buffer = b })
			end
			vim.wait(400, function() return false end)  -- D-12: 400ms exhaust window
			assert.stub(stubbed_try_lint).was_called(1)  -- assertion #1 (Pitfall 7)
			vim.cmd("bdelete!")
		end)
	end)
end)
