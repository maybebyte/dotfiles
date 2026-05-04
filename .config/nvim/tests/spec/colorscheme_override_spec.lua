-- Parity: tests/startup/tests/colorscheme-override.sh — 2 assertions
-- D-05: bifurcated — Part 1 subprocess (initial Normal.bg), Part 2 in-process (override survives swap).
-- D-06: catppuccin seeded via vim.opt.rtp:prepend (Wave B convention).
-- D-07: Part 2 snapshots vim.g.colors_name in before_each, restores via pcall in after_each.
-- D-08 Option 3 (RESEARCH § Override-Autocmd Registration Decision): full dofile(init.lua).
-- D-18: H.assert_no_lua_error after every H.nvim_child call.
-- D-19: Part 1 args shape verbatim from CONTEXT.md.
-- D-21: explicit +qa! terminator (helper does NOT auto-append).

local H = require("tests.spec.helpers")

-- D-06: seed catppuccin into the plenary headless runtime (mirrors lint_on_open_spec.lua L16-17).
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/catppuccin")

describe("PORT-12 colorscheme override", function()
	-- D-05 + D-19 + D-21 — Part 1 subprocess: initial Normal.bg before any colorscheme loads.
	it("Part 1: initial Normal.bg is nil/NONE [subprocess]", function()
		local r = H.nvim_child({
			args = {
				"-c",
				"lua local hl = vim.api.nvim_get_hl(0, { name = 'Normal' }); io.write(tostring(hl.bg))",
				"+qa!",
			},
		})
		assert.equals(0, r.exit)
		H.assert_no_lua_error(r) -- D-18
		local last = r.stdout:match("([^\n]+)%s*$") or "" -- D-20
		assert.is_true(
			last == "nil" or last == "" or last == "NONE",
			"initial Normal.bg = " .. last .. " (expected nil/NONE)"
		)
	end)

	-- D-05 + D-06 + D-07 + D-08 Option 3 — Part 2 in-process: override survives :colorscheme swap.
	describe("Part 2: in-process colorscheme swap", function()
		local snapshot

		before_each(function()
			vim.g.my_config_loaded = nil -- re-arm resource guard (resource_guard_spec.lua L23 idiom)
			dofile(vim.fn.getcwd() .. "/init.lua") -- D-08 Option 3 — full init re-source
			snapshot = vim.g.colors_name -- D-07 capture
		end)

		after_each(function()
			if snapshot then
				pcall(vim.cmd.colorscheme, snapshot) -- D-07; pcall per CLAUDE.md "ALWAYS pcall"
			end
		end)

		it("override survives :colorscheme catppuccin-mocha [in-process]", function()
			vim.cmd.colorscheme("default") -- bash baseline L24
			vim.cmd.colorscheme("catppuccin-mocha") -- bash baseline L25
			local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
			assert.is_true(
				hl.bg == nil or hl.bg == "NONE",
				"post-swap Normal.bg = " .. tostring(hl.bg) .. " (expected nil/NONE per my_highlight_overrides)"
			)
		end)
	end)
end)
