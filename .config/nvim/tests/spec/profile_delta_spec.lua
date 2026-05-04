-- tests/spec/profile_delta_spec.lua — Phase 8 (PORT-15)
-- Parity: tests/startup/tests/profile-delta.sh — 2 assertions
-- Pending under PORT-15 exception — see body string for measured gap.
-- 2 body assertions (zero-guard + 15% headroom) are mooted under the
-- pending path; tests/startup/tests/profile-delta.sh remains the
-- maintained source of truth (D-16 carve-out cascade for Phase 9).
--
-- Decision references (see .planning/phases/08-performance-spec/08-CONTEXT.md):
--   D-04: pending() decision is sticky for v1.1
--   D-08/D-22: hard-fail on missing/invalid baseline file (prereq diagnostic)
--   D-09: 5x sequential H.nvim_child, payload mirror, timeout=8000 (live path)
--   D-13: stdout last-line extraction via match("([^\n]+)%s*$") (live path)
--   D-14: pending body string with measured X/Y numbers
--   D-15: gap recorded in BOTH spec body and 08-01-SUMMARY.md
--   D-19: second-line comment "Pending under PORT-15 exception"
--   D-23: zero-guard + headroom messages preserved in dead branch for parity reference

-- D-22 three-check baseline guard at module load (hard-fail noisily on prereq
-- breakage even under pending — diagnostic value retained per PLAN Task 3
-- Branch B). Diagnostic messages name the path.
local _baseline_path = vim.fs.joinpath(
	vim.fn.getcwd(),
	".planning",
	"phases",
	"01-startup-init-hygiene",
	"baseline-startuptime.txt"
)
assert(
	vim.fn.filereadable(_baseline_path) == 1,
	"baseline file not readable: " .. _baseline_path
)
local _raw = vim.fn.readfile(_baseline_path)[1]
local _baseline = tonumber(_raw)
assert(
	_baseline ~= nil,
	"baseline file is not a number: " .. _baseline_path .. " (got: " .. tostring(_raw) .. ")"
)
assert(
	_baseline > 0,
	"baseline value must be > 0: " .. _baseline_path .. " (got: " .. tostring(_baseline) .. ")"
)

describe("profile-delta (LazyDone min-of-5 vs Phase 1 baseline)", function()
	it("min-of-5 LazyDone time is non-zero and within 15% headroom of baseline", function()
		-- D-14 pending body: live measured X (worst-case min-of-5 across the
		-- 5 pre-flight trials on Qubes dev qube, 2026-05-04) and Y (gap over
		-- baseline). Numbers mirror those in 08-01-SUMMARY.md trial table per D-15.
		pending(
			"PORT-15 exception: Qubes triple-nested spawn min-of-5 = 50.95ms vs baseline 21.998793ms"
				.. " (gap +28.95ms exceeds 20ms threshold). "
				.. "tests/startup/tests/profile-delta.sh remains source of truth. "
				.. "See 08-CONTEXT.md D-14, D-16."
		)

		-- ============================================================
		-- DEAD BRANCH (kept as parity reference; pending() above short-circuits).
		-- The two body assertions below are the D-23/D-24 zero-guard +
		-- 15% headroom assertions that would run on the live path.
		-- They are referenced in the parity comment at the top of the file.
		-- ============================================================
		if false then
			local H = require("tests.spec.helpers")
			-- D-09 measurement payload — VERBATIM mirror of lib.sh L21 nvim_startuptime_ms.
			local measurement_payload =
				'lua local s = require("lazy").stats(); io.write(tostring(s.times and (s.times.LazyDone or 0) or 0))'
			local samples = {}
			for i = 1, 5 do
				local r = H.nvim_child({
					args = { "-c", measurement_payload, "+qa!" },
					timeout = 8000, -- D-09 Qubes cold-start cushion
				})
				assert.is_true(
					r.exit == 0,
					"sample " .. i .. ": H.nvim_child exit=" .. tostring(r.exit) .. " stderr=" .. tostring(r.stderr)
				)
				local n = tonumber((r.stdout or ""):match("([^\n]+)%s*$"))
				assert.is_true(
					n ~= nil,
					"sample " .. i .. ": could not parse LazyDone from stdout=" .. string.format("%q", r.stdout or "")
				)
				samples[i] = n
			end
			table.sort(samples)
			local current = samples[1]
			local ratio = current / _baseline

			-- ASSERTION 1 of 2 (D-23 first; D-24 parity slot 1) — zero-guard.
			assert.is_true(
				current > 0,
				"LazyDone time is zero/empty — lazy.nvim may not have loaded in headless mode"
			)

			-- ASSERTION 2 of 2 (D-23 second; D-24 parity slot 2) — 15% headroom.
			assert.is_true(
				current <= _baseline * 1.15,
				"startup regressed: baseline=" .. _baseline .. " current=" .. current .. " (ratio " .. ratio .. ")"
			)
		end
	end)
end)
