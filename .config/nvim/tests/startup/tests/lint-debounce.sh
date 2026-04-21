#!/usr/bin/env bash
# Test SC-6 / LINT-02: 3 rapid BufWritePost triggers within 150ms fire try_lint exactly ONCE.
# Monkey-patches require("lint").try_lint to count calls via _G.__lint_calls.
# Uses nvim_exec_autocmds in a tight Lua loop to get truly rapid triggers — `:write | write | write`
# in an ex pipe ran ~100-200ms per write on Qubes (disk IO variance), which exceeds the 150ms
# debounce window and defeats the test's intent.
# Expected: FAIL against current HEAD (no debounce — autocmd fires try_lint 3 times); GREEN after Plan 02-03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

tmpfile="$(mktemp --suffix=.py)"
printf 'x = 1\n' > "$tmpfile"

raw="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua _G.__lint_calls = 0; local L = require("lint"); local orig = L.try_lint; L.try_lint = function(...) _G.__lint_calls = _G.__lint_calls + 1; return orig(...) end' \
	-c 'lua local b = vim.api.nvim_get_current_buf(); for _ = 1, 3 do vim.api.nvim_exec_autocmds("BufWritePost", { buffer = b }) end' \
	-c 'lua vim.wait(400, function() return false end)' \
	-c 'lua io.write("__LINTCOUNT="..tostring(_G.__lint_calls).."__")')"
rm -f "$tmpfile"

out="$(printf '%s' "$raw" | sed -n 's/.*__LINTCOUNT=\([0-9]*\)__.*/\1/p')"

assert_eq "1" "$out" "debounce failed: expected 1 try_lint call for 3 rapid BufWritePost triggers, got $out (raw=$raw)"
