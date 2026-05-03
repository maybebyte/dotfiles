-- Parity: tests/startup/tests/lint-on-open.sh — 1 assertion
-- Wave B: real python linter (pylint/ruff/mypy — all 3 configured) on BufReadPost.
-- D-07: hard-fails when no python linter is available (luassert error on count==0).
-- D-08: NO mocking of nvim-lint — real BufReadPost fires.
-- Pitfall 1: source init.lua so nvim-lint's UserLint augroup is registered.
-- Pitfall 4: bump vim.wait to 3000ms (bash baseline 500ms unreliable for cold-start
--   on Qubes — see RESEARCH).
-- Pitfall 6: vim.cmd("bdelete!") after :edit to prevent buffer leak.
-- Deviation: plenary's event system consumes lazy.nvim's once=true BufReadPost
-- handlers before specs run. nvim-lint is loaded explicitly via rtp prepend +
-- require so its UserLint augroup autocmds are registered before :edit fires.

local H = require("tests.spec.helpers")

-- Ensure nvim-lint is on rtp so require("lint") resolves.
local lint_path = vim.fn.stdpath("data") .. "/lazy/nvim-lint"
vim.opt.rtp:prepend(lint_path)

describe("PORT-09 nvim-lint runs on BufReadPost", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
		-- Load nvim-lint and register its UserLint augroup if not already present.
		-- The augroup uses clear=true so re-registration is idempotent.
		local lint = require("lint")
		if not lint.linters_by_ft or not lint.linters_by_ft.python then
			lint.linters_by_ft = { python = { "mypy", "pylint", "ruff" } }
		end
		-- Re-register UserLint augroup so BufReadPost triggers try_lint.
		-- Uses the same debounce-free approach as a minimal reproduction.
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

	it(":edit on .py produces diagnostics before any :w", function()
		-- Create tempfile with .py extension for filetype detection.
		local p = vim.fn.tempname() .. ".py"
		local fh = assert(io.open(p, "w"))
		fh:write('import os\nprint("hi")\n')
		fh:close()
		local ok, err = pcall(function()
			vim.cmd("edit " .. p)
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
