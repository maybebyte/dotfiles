#!/usr/bin/env bash
# Test LSP-02 / D-23: inlay hints enabled after LspAttach on a capable server.
# Tries gopls first (primary — CONTEXT.md D-23 authoritative), falls back to
# lua_ls with type-annotated Lua content. Skips if neither installed.
# SLOW: LSP startup takes 2-5s. Added to QUICK_SKIP in run.sh.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

# Pick the first available server. Mason-installed binaries live under
# ~/.local/share/nvim/mason/bin/; `command -v` only sees them if that dir
# is on PATH (mason.lua lazy=false priority=100 handles this for nvim).
# For pre-nvim detection we check both PATH and the Mason bin dir directly.
MASON_BIN="${MASON_BIN:-$HOME/.local/share/nvim/mason/bin}"

have_server() {
	local name="$1"
	command -v "$name" >/dev/null 2>&1 && return 0
	[ -x "$MASON_BIN/$name" ] && return 0
	return 1
}

if have_server gopls; then
	ft_suffix=".go"
	content='package main

func main() {
	_ = add(1, 2)
}

func add(a int, b int) int { return a + b }
'
	server_label="gopls"
elif have_server lua-language-server; then
	ft_suffix=".lua"
	# lua_ls inlay hints require BOTH hint.enable=true in server settings
	# (Plan 02 Task 2 adds that to settings.Lua) AND code that produces hints.
	# Type-annotated locals + @param/@return annotations are canonical
	# hint-producing shapes. Per checker warning #5: do NOT use trivial
	# untyped code here — is_enabled may report "true" (enable call succeeded)
	# but no hints would be visible, violating SC-3's "visible hints" intent.
	content='---@type integer[]
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
'
	server_label="lua_ls"
else
	echo "SKIP: neither gopls nor lua-language-server installed"
	exit 0
fi

tmpfile="$(mktemp --suffix="$ft_suffix")"
trap 'rm -f "$tmpfile"' EXIT
printf '%s' "$content" > "$tmpfile"

# vim.wait polls up to 5s for LSP attach + hint enable. Returns true as soon as
# is_enabled returns truthy. Final io.write prints the current state.
# We check is_enabled for the current buffer (bufnr=0) since LspAttach enables
# per-buffer (Plan 02 Task 1 callback).
out="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua vim.wait(5000, function() return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) end)' \
	-c 'lua io.write(tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))')"

# nvim_headless returns combined stdout+stderr; the last line is our io.write.
last="$(printf '%s\n' "$out" | tail -n 1 | tr -d '[:space:]')"

# Defense-in-depth: nvim_headless does NOT abort on Lua errors inside
# `-c 'lua ...'` blocks (see lib.sh notes). A regression in LspAttach could
# emit a traceback but still exit 0 with "false"/"nil" as the last line,
# masking the real cause. Mirror the cap-guard test's error sniff.
if printf '%s\n' "$out" | grep -qE '(E5108|stack traceback|attempt to call|attempt to index)'; then
	echo "Lua error in LspAttach path:" >&2
	printf '%s\n' "$out" >&2
	exit 1
fi

assert_eq "true" "$last" "inlay hints enabled after LspAttach ($server_label)"

# gopls branch: also verify extmarks with virt_text are actually rendered.
# is_enabled returns true as soon as enable() is called — even if gopls sent
# zero hints (false positive). This second check detects that gap.
if [ "$server_label" = "gopls" ]; then
	hint_count="$(nvim_headless \
		-c "edit $tmpfile" \
		-c 'lua
local buf = 0
-- Wait for LSP attach (up to 5s)
vim.wait(5000, function()
    return vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
end)
-- Wait for extmarks to populate (up to 3s)
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
')"
	hint_count="$(printf '%s\n' "$hint_count" | tail -n 1 | tr -d '[:space:]')"
	# count must be a positive integer; "0" or empty string means false pass
	if ! echo "$hint_count" | grep -qE '^[1-9][0-9]*$'; then
		echo "assertion failed: gopls extmark hints not rendered (count=$hint_count)" >&2
		exit 1
	fi
	echo "gopls extmark hint count: $hint_count"
fi
