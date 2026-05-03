-- tests/spec/smoke_spec.lua — Phase 5 canary (TESTINFRA-06)
-- Proves: helper API reachable, package.path resolution, my.utils require.
-- Maps to phase success criteria #3 + #4. Decisions: D-33.

local H = require("tests.spec.helpers")

describe("harness loads", function()
	it("require('my.utils') resolves and exposes is_git_repo", function()
		local utils = require("my.utils")
		assert.is_table(utils)
		assert.is_function(utils.is_git_repo)
	end)

	it("H.assert_contains finds substring", function()
		H.assert_contains("hello world", "world")
	end)

	it("H.wait_for returns true when cond is immediately true", function()
		assert.is_true(H.wait_for(function()
			return true
		end, 100))
	end)

	it("H.force_very_lazy fires User VeryLazy without error", function()
		H.force_very_lazy()
	end)

	it("H.with_temp_file passes a path and runs cleanup", function()
		local seen
		H.with_temp_file("hello", function(p)
			seen = p
			assert.is_string(p)
		end)
		assert.is_string(seen)
	end)

	it("H.tmp_git_dir creates a dir and runs cleanup", function()
		local seen
		H.tmp_git_dir(function(p)
			seen = p
			assert.is_string(p)
		end)
		assert.is_string(seen)
	end)

	it("H.notify_stub captures calls and restores vim.notify", function()
		local n = H.notify_stub()
		vim.notify("hi")
		assert.equals(1, #n.calls)
		assert.equals("hi", n.calls[1].msg)
		n:restore()
	end)

	it("H.with_fresh_module clears package.loaded around fn", function()
		H.with_fresh_module("my.utils", function(m)
			assert.is_table(m)
		end)
	end)

	it("H.nvim_child boots a child and exits 0", function()
		local r = H.nvim_child({ args = { "+qa!" }, timeout = 10000 })
		assert.equals(0, r.exit)
	end)
end)
