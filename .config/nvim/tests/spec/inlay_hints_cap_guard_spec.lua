-- Parity: tests/startup/tests/inlay-hints-cap-guard.sh — 1 assertion (effective)
-- D-13: yamlls only — single it() block.
-- D-14: H.nvim_child timeout = 8000ms (3s LSP-attach wait + slack).
-- D-15: hard-fail on missing yaml-language-server (no pending(), no skip).
-- D-18 LOAD-BEARING: H.assert_no_lua_error catches future supports_method() throws —
--                    this is the actual regression catch, NOT the is_enabled==false check
--                    (yamlls never advertises inlayHintProvider regardless of guard correctness).
-- D-20: stdout last-line extraction inline; D-21: explicit +qa! terminator.
-- Pitfall 2 (PATTERNS.md § S-6): tempfile renamed with .yaml suffix for ft detection.
-- Mason-bin: prepend to PATH so vim.fn.executable() finds mason-managed servers (D-15).

local H = require("tests.spec.helpers")

-- Mirrors bash have_server(): yaml-language-server lives in Mason bin, not system PATH.
-- Prepend Mason bin so vim.fn.executable() resolves it correctly (D-15 precondition).
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

describe("PORT-14 inlay hint cap guard (yamlls negative path)", function()
	it("yamlls attaches but inlay hints stay disabled", function()
		assert.equals(
			1,
			vim.fn.executable("yaml-language-server"),
			"yaml-language-server required (mason: :MasonInstall yaml-language-server)"
		) -- D-15

		H.with_temp_file("foo: bar\nbaz:\n  - one\n  - two\n", function(p)
			local yaml_path = p .. ".yaml"
			vim.fn.rename(p, yaml_path) -- Pitfall 2: ft detection requires .yaml suffix
			local r = H.nvim_child({
				args = {
					"-c",
					"edit " .. yaml_path,
					"-c",
					"lua vim.wait(3000, function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end)",
					"-c",
					"lua io.write(tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))",
					"+qa!",
				},
				timeout = 8000, -- D-14
			})
			vim.fn.delete(yaml_path) -- cleanup the suffixed rename (helper only deletes p)
			assert.equals(0, r.exit)
			H.assert_no_lua_error(r) -- D-18 LOAD-BEARING regression catch
			local last = r.stdout:match("([^\n]+)%s*$") or "" -- D-20
			assert.equals(
				"false",
				last,
				"yamlls is_enabled was " .. last .. " (expected false — no inlayHintProvider)"
			)
		end)
	end)
end)
