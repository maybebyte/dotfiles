-- Parity: tests/startup/tests/autoformat-toggle.sh — 2 assertions
-- Wave C: real `black` binary (D-07 hard-fail if missing).
-- D-08: NO mocking of conform; real BufWritePre fires.
-- Pitfall 1: source init.lua so conform's format_on_save handler is registered.
-- Pitfall 6: vim.cmd("bdelete!") after each :edit.
-- Note: tempfile must have .py suffix so ft=python triggers conform lazy load.
-- Deviation: same as PORT-08 — lazy once=true ft handlers consumed before specs
-- run; conform loaded via rtp prepend + require so BufWritePre is registered.

local H = require("tests.spec.helpers")

-- Ensure conform.nvim is on rtp so require("conform") resolves.
local conform_path = vim.fn.stdpath("data") .. "/lazy/conform.nvim"
vim.opt.rtp:prepend(conform_path)

describe("PORT-06 vim.g.autoformat global toggle", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
		-- Ensure conform is loaded with BufWritePre handler registered.
		local conform = require("conform")
		if vim.g.autoformat == nil then
			vim.g.autoformat = true
			conform.setup({
				formatters_by_ft = { python = { "black" } },
				format_on_save = function(bufnr)
					local effective = vim.b[bufnr].autoformat
					if effective == nil then
						effective = vim.g.autoformat
					end
					if not effective then
						return
					end
					return { timeout_ms = 3000, lsp_format = "fallback" }
				end,
			})
		end
	end)

	-- Reset vim.g.autoformat between specs so the `if vim.g.autoformat == nil`
	-- guard re-arms on every `before_each`. Without this, an `H.assert_contains`
	-- failure on the unformatted assertion leaves vim.g.autoformat=false and
	-- silently disables formatting in subsequent specs (see REVIEW MD-01/MD-02).
	after_each(function()
		vim.g.autoformat = nil
	end)

	it("autoformat=false suppresses; autoformat=true restores", function()
		local pOff = vim.fn.tempname() .. ".py"
		local fh1 = assert(io.open(pOff, "w"))
		fh1:write("def  f( x ):return x+1\n")
		fh1:close()
		local ok1, err1 = pcall(function()
			vim.cmd("edit " .. pOff)
			vim.g.autoformat = false
			vim.cmd("write")
			vim.wait(3000, function()
				return not vim.b.conform_applying_formatting
			end)
			local off = table.concat(vim.fn.readfile(pOff), "\n")
			H.assert_contains(off, "def  f( x )")  -- assertion #1 (unformatted preserved)
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(pOff)
		if not ok1 then error(err1, 2) end

		local pOn = vim.fn.tempname() .. ".py"
		local fh2 = assert(io.open(pOn, "w"))
		fh2:write("def  g( y ):return y+2\n")
		fh2:close()
		local ok2, err2 = pcall(function()
			vim.cmd("edit " .. pOn)
			vim.g.autoformat = true
			vim.cmd("write")
			vim.wait(3000, function()
				return not vim.b.conform_applying_formatting
			end)
			local on = table.concat(vim.fn.readfile(pOn), "\n")
			H.assert_contains(on, "def g(y):")  -- assertion #2 (formatted)
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(pOn)
		if not ok2 then error(err2, 2) end
	end)
end)
