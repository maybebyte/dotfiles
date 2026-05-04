-- Parity: tests/startup/tests/format-on-save.sh — 1 assertion
-- Wave B: real `black` binary on python tempfile.
-- D-07: hard-fails (luassert error) when `black` is absent — by design.
-- D-08: NO mocking of conform — real BufWritePre fires and runs black.
-- Pitfall 1: source init.lua so conform's BufWritePre handler is registered.
-- Pitfall 6: vim.cmd("bdelete!") after :edit to prevent buffer leak.
-- Note: tempfile must have .py suffix so ft=python triggers conform lazy load.
-- format_on_save uses timeout_ms=3000 (synchronous); :write blocks until done.
-- Deviation: plenary's event system consumes lazy.nvim's once=true ft handlers
-- before specs run. Conform must be loaded explicitly via rtp prepend + require
-- so its BufWritePre autocmd is registered before :write fires.

local H = require("tests.spec.helpers")

-- Ensure conform.nvim is on rtp so require("conform") resolves.
-- lazy.nvim's ft-triggered loading (once=true autocmds) is consumed before
-- specs run in the plenary headless environment; manual rtp prepend bridges
-- the gap without relying on lazy's event system.
local conform_path = vim.fn.stdpath("data") .. "/lazy/conform.nvim"
vim.opt.rtp:prepend(conform_path)

describe("PORT-08 conform format-on-save fires on BufWritePre", function()
	before_each(function()
		vim.g.my_config_loaded = nil
		dofile(vim.fn.getcwd() .. "/init.lua")
		-- Ensure conform is loaded and BufWritePre handler is registered.
		-- Call setup only if not already configured to avoid double-registration.
		local conform = require("conform")
		if vim.g.autoformat == nil then
			vim.g.autoformat = true
			conform.setup({
				formatters_by_ft = { python = { "black" } },
				-- Mirror conform.lua's buffer-local-first logic so this spec
				-- exercises the same callback shape regardless of whether it
				-- runs in isolation or as part of the full suite (LW-01).
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
	-- guard re-arms on every `before_each`, ensuring this spec is independent
	-- of execution order (see REVIEW MD-01).
	after_each(function()
		vim.g.autoformat = nil
	end)

	it(":w on bad-formatted .py file triggers black", function()
		local p = vim.fn.tempname() .. ".py"
		local fh = assert(io.open(p, "w"))
		fh:write("def  f( x ):return x+1\n")
		fh:close()
		local ok, err = pcall(function()
			vim.cmd("edit " .. p)
			vim.cmd("write")
			vim.wait(3000, function()
				return not vim.b.conform_applying_formatting
			end)
			local content = table.concat(vim.fn.readfile(p), "\n")
			H.assert_contains(content, "def f(x):")  -- assertion #1
			vim.cmd("bdelete!")
		end)
		vim.fn.delete(p)
		if not ok then
			error(err, 2)
		end
	end)
end)
