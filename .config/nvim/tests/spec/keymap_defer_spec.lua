-- Parity: tests/startup/tests/keymap-defer.sh — 2 assertions
-- Wave B: autocmd-trigger. Sources init.lua so User VeryLazy autocmd
-- (init.lua line 100) is registered, then fires it via H.force_very_lazy.
-- Pitfall 1: minimal_init does NOT auto-load my.* — source init.lua first.
-- Pitfall 2: use vim.fn.getcwd() — vim.env.MYVIMRC points at minimal_init
--   under `-u tests/minimal_init.lua`.

local H = require("tests.spec.helpers")

describe("PORT-04 keymap defer to VeryLazy", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
	end)

	it("<C-h> is unmapped before VeryLazy and mapped after", function()
		local pre = vim.fn.maparg("<C-h>", "n")
		assert.equals("", pre)        -- assertion #1 (pre-VeryLazy empty)
		H.force_very_lazy()
		local post = vim.fn.maparg("<C-h>", "n")
		assert.is_true(#post > 0)     -- assertion #2 (post-VeryLazy non-empty)
	end)
end)
