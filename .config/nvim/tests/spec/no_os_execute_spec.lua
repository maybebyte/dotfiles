-- Parity: tests/startup/tests/no-os-execute.sh — 1 assertion
-- Wave A: static file inspection. No plugin load, no autocmds fire.
-- Bash baseline checks init.lua only (NOT lua/**); strict bash parity per
-- RESEARCH Open Question 1. Widening to lua/** is deferred.

local H = require("tests.spec.helpers")

describe("PORT-01 no os.execute in init.lua", function()
	it("init.lua contains no os.execute call", function()
		local lines = vim.fn.readfile(vim.fn.getcwd() .. "/init.lua")
		for _, line in ipairs(lines) do
			assert.is_nil(line:find("os%.execute"),
				"os.execute found in init.lua: " .. line)
		end
	end)
end)
