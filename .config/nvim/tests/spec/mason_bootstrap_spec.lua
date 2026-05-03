-- Parity: tests/startup/tests/mason-bootstrap.sh — 18 assertions
--   (12 LSP names + lazy=false + run_on_start=true + auto_update=false
--    + count >= 25 + count <= 28 + file exists)
-- Wave A: static file inspection.

local H = require("tests.spec.helpers")

describe("PORT-02 mason-tool-installer bootstrap", function()
	local PLUGIN_FILE = vim.fn.getcwd() .. "/lua/my/plugins/mason-tool-installer.lua"
	local LSP_SERVERS = {
		"lua_ls", "pyright", "gopls", "bashls", "rust_analyzer", "ts_ls",
		"cssls", "html", "jsonls", "yamlls", "stylelint_lsp", "marksman",
	}

	it("plugin spec file exists", function()
		assert.equals(1, vim.fn.filereadable(PLUGIN_FILE))  -- assertion #1
	end)

	it("ensure_installed entry count is in [25, 28]", function()
		local lines = vim.fn.readfile(PLUGIN_FILE)
		local count = 0
		for _, line in ipairs(lines) do
			if line:match('^%s+"[^"]+"') then count = count + 1 end
		end
		assert.is_true(count >= 25, "count " .. count .. " < 25")  -- #2
		assert.is_true(count <= 28, "count " .. count .. " > 28")  -- #3
	end)

	it("contains all 12 D-06 authoritative LSP server names", function()
		local content = table.concat(vim.fn.readfile(PLUGIN_FILE), "\n")
		for _, server in ipairs(LSP_SERVERS) do
			-- assertions #4..#15 (one per server)
			H.assert_contains(content, '"' .. server .. '"')
		end
	end)

	it("declares lazy=false, run_on_start=true, auto_update=false", function()
		local content = table.concat(vim.fn.readfile(PLUGIN_FILE), "\n")
		H.assert_contains(content, "lazy = false")          -- #16
		H.assert_contains(content, "run_on_start = true")    -- #17
		H.assert_contains(content, "auto_update = false")    -- #18
	end)
end)
