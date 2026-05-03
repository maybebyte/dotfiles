-- Parity: tests/startup/tests/clipboard-defer.sh — 1 assertion
-- Wave B: asserts pre-VeryLazy state (mirrors bash baseline; bash baseline
-- does NOT fire VeryLazy — only checks the clear-at-init step in init.lua
-- line 57: vim.opt.clipboard = "").
-- Pitfall 1: source init.lua so the clear-at-init pattern actually runs.
-- Pitfall 2: use vim.fn.getcwd() (not vim.env.MYVIMRC).

describe("PORT-05 clipboard deferred until VeryLazy", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
	end)

	it("vim.opt.clipboard is empty pre-VeryLazy", function()
		local current = table.concat(vim.opt.clipboard:get(), ",")
		assert.equals("", current)  -- assertion #1
	end)
end)
