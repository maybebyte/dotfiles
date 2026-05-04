-- Parity: tests/startup/tests/inlay-hints-attach.sh — 2 effective assertions
--   Lua port has 4 (D-23 "OK Lua > bash by design — D-09 separate it() per server").
-- D-09: two it() blocks (gopls + lua_ls), independent — NOT bash's first-available fallback.
-- D-10: gopls extmark probe lifted VERBATIM from bash baseline L100-126.
-- D-11: lua_ls content lifted VERBATIM from bash baseline L43-59 (---@type/@param/@return required).
-- D-12: H.nvim_child timeout = 15000ms (gopls boot + 5s is_enabled + 3s extmark + slack).
-- D-15: hard-fail on missing binary (assert.equals(1, vim.fn.executable(...))) at top of EACH it().
-- D-18: H.assert_no_lua_error after every H.nvim_child call.
-- D-20: stdout last-line extraction inline.
-- D-21: explicit +qa! terminator on every H.nvim_child call.
-- Pitfall 2 (PATTERNS.md § S-6): tempfile renamed with .go / .lua suffix for ft detection.
-- Mason-bin: prepend to PATH so vim.fn.executable() finds mason-managed servers (D-15 precondition).

local H = require("tests.spec.helpers")

-- Mirrors bash have_server(): gopls and lua-language-server live in Mason bin, not system PATH.
-- Prepend Mason bin so vim.fn.executable() resolves them correctly (D-15 precondition).
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- D-10 — gopls extmark probe, lifted verbatim from inlay-hints-attach.sh L100-126.
-- Walks nvim_get_namespaces (returns name->id table), pattern-matches "inlayhint" OR
-- "inlay_hint" (varies by Neovim version), counts virt_text-bearing extmarks.
local extmark_probe = [[
local buf = 0
vim.wait(5000, function()
    return vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
end)
local count = 0
vim.wait(3000, function()
    local ns_id = -1
    for name, id in pairs(vim.api.nvim_get_namespaces()) do
        if name:find("inlayhint") or name:find("inlay_hint") then
            ns_id = id
            break
        end
    end
    if ns_id == -1 then return false end
    local marks = vim.api.nvim_buf_get_extmarks(buf, ns_id, 0, -1, { details = true })
    count = 0
    for _, m in ipairs(marks) do
        if m[4] and m[4].virt_text and #m[4].virt_text > 0 then
            count = count + 1
        end
    end
    return count > 0
end)
io.write(tostring(count))
]]

describe("PORT-13 inlay hints attach", function()
	it("gopls inlay hints attach + extmark probe", function()
		assert.equals(
			1,
			vim.fn.executable("gopls"),
			"gopls required (mason: :MasonInstall gopls)"
		) -- D-15

		-- Minimal Go file with one parameter-named call so gopls emits a:/b: hints.
		local go_content = [[package main

func main() {
	_ = add(1, 2)
}

func add(a int, b int) int { return a + b }
]]

		H.with_temp_file(go_content, function(p)
			local go_path = p .. ".go"
			vim.fn.rename(p, go_path) -- Pitfall 2
			local r = H.nvim_child({
				args = {
					"-c",
					"edit " .. go_path,
					"-c",
					"lua " .. extmark_probe,
					"+qa!",
				},
				timeout = 15000, -- D-12
			})
			vim.fn.delete(go_path) -- cleanup suffixed rename
			assert.equals(0, r.exit)
			H.assert_no_lua_error(r) -- D-18
			local last = r.stdout:match("([^\n]+)%s*$") or "" -- D-20
			assert.is_true(
				last:match("^[1-9]%d*$") ~= nil,
				"gopls extmark count = " .. last .. " (expected positive integer)"
			)
		end)
	end)

	it("lua_ls inlay hints attach + is_enabled", function()
		assert.equals(
			1,
			vim.fn.executable("lua-language-server"),
			"lua-language-server required (mason: :MasonInstall lua-language-server)"
		) -- D-15

		-- D-11: byte-for-byte from inlay-hints-attach.sh L43-59 (Pitfall 6: lua_ls needs annotations).
		local lua_content = [[---@type integer[]
local numbers = { 1, 2, 3, 4, 5 }

---@param xs integer[]
---@return integer
local function sum(xs)
	local total = 0
	for _, v in ipairs(xs) do
		total = total + v
	end
	return total
end

---@type integer
local result = sum(numbers)
print(result)
]]

		H.with_temp_file(lua_content, function(p)
			local lua_path = p .. ".lua"
			vim.fn.rename(p, lua_path) -- Pitfall 2
			local r = H.nvim_child({
				args = {
					"-c",
					"edit " .. lua_path,
					"-c",
					"lua vim.wait(5000, function() return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) end)",
					"-c",
					"lua io.write(tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))",
					"+qa!",
				},
				timeout = 15000, -- D-12
			})
			vim.fn.delete(lua_path)
			assert.equals(0, r.exit)
			H.assert_no_lua_error(r) -- D-18
			local last = r.stdout:match("([^\n]+)%s*$") or "" -- D-20
			assert.equals(
				"true",
				last,
				"lua_ls is_enabled = " .. last .. " (expected true)"
			)
		end)
	end)
end)
