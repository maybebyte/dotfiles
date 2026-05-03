-- Parity: tests/startup/tests/autoformat-buffer.sh — 2 assertions
-- Wave C: real `black` binary; vim.b.autoformat=false on buffer A overrides
--   global vim.g.autoformat=true. Buffer B (no buffer-local) inherits global.
-- Pitfall 1: source init.lua so conform's format_on_save reads vim.b.autoformat first.
-- Pitfall 6: vim.cmd("bdelete!") after each :edit.
-- Note: tempfile must have .py suffix so ft=python triggers conform lazy load.
-- Deviation: same as PORT-06/08 — lazy once=true ft handlers consumed before specs
-- run; conform loaded via rtp prepend + require so BufWritePre is registered.

local H = require("tests.spec.helpers")

-- Ensure conform.nvim is on rtp so require("conform") resolves.
local conform_path = vim.fn.stdpath("data") .. "/lazy/conform.nvim"
vim.opt.rtp:prepend(conform_path)

describe("PORT-07 vim.b.autoformat buffer-local override", function()
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

	it("buffer-local autoformat=false beats global autoformat=true", function()
		vim.g.autoformat = true
		local pA = vim.fn.tempname() .. ".py"
		local fh1 = assert(io.open(pA, "w"))
		fh1:write("def  f( x ):return x+1\n")
		fh1:close()
		local ok1, err1 = pcall(function()
			vim.cmd("edit " .. pA)
			vim.b.autoformat = false
			vim.cmd("write")
			vim.wait(3000, function()
				return not vim.b.conform_applying_formatting
			end)
			local a = table.concat(vim.fn.readfile(pA), "\n")
			H.assert_contains(a, "def  f( x )")  -- assertion #1 (buffer-local override)
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(pA)
		if not ok1 then error(err1, 2) end

		local pB = vim.fn.tempname() .. ".py"
		local fh2 = assert(io.open(pB, "w"))
		fh2:write("def  g( y ):return y+2\n")
		fh2:close()
		local ok2, err2 = pcall(function()
			vim.cmd("edit " .. pB)  -- inherits vim.g.autoformat = true (no vim.b override)
			vim.cmd("write")
			vim.wait(3000, function()
				return not vim.b.conform_applying_formatting
			end)
			local b = table.concat(vim.fn.readfile(pB), "\n")
			H.assert_contains(b, "def g(y):")  -- assertion #2 (global inherited)
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(pB)
		if not ok2 then error(err2, 2) end
	end)
end)
