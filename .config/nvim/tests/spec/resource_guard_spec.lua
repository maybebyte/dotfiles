-- Parity: tests/startup/tests/resource-guard.sh — 1 assertion
-- D-16: re-source init.lua twice; assert my_highlight_overrides augroup
-- count is unchanged (idempotency guard from Phase 1).
-- Pitfall 2: use vim.fn.getcwd() .. "/init.lua" (NOT vim.env.MYVIMRC, which
--   points at minimal_init.lua under `-u tests/minimal_init.lua`).
-- Pitfall 3: vim.g.my_config_loaded MUST be reset to nil BETWEEN dofile
--   calls — otherwise the second dofile early-returns at line 1-3 and the
--   test passes trivially.

describe("PORT-03 resource guard prevents augroup duplication", function()
	local prior_loaded

	before_each(function()
		prior_loaded = vim.g.my_config_loaded
	end)

	after_each(function()
		vim.g.my_config_loaded = prior_loaded  -- D-16: restore
	end)

	it("re-sourcing init.lua does not duplicate my_highlight_overrides autocmds", function()
		local INIT = vim.fn.getcwd() .. "/init.lua"
		vim.g.my_config_loaded = nil
		dofile(INIT)
		local n1 = #vim.api.nvim_get_autocmds({ group = "my_highlight_overrides" })
		vim.g.my_config_loaded = nil  -- Pitfall 3: re-arm guard between dofiles
		dofile(INIT)
		local n2 = #vim.api.nvim_get_autocmds({ group = "my_highlight_overrides" })
		assert.equals(n1, n2)  -- assertion #1
	end)
end)
