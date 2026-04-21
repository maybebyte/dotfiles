#!/usr/bin/env bash
# Test SC-3 / FORMAT-03: vim.b.autoformat tri-state override — buffer-local beats global.
# Expected: FAIL against current HEAD (no vim.b.autoformat wiring); GREEN after Plan 02-02.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

fA="$(mktemp --suffix=.py)"
fB="$(mktemp --suffix=.py)"
printf 'def  f( x ):return x+1\n' > "$fA"
printf 'def  g( y ):return y+2\n' > "$fB"

nvim_headless \
	-c 'lua vim.g.autoformat = true' \
	-c "edit $fA" \
	-c 'lua vim.b.autoformat = false' \
	-c 'write' \
	-c 'lua vim.wait(3000, function() return not require("conform").formatting(0) end)' \
	-c "edit $fB" \
	-c 'write' \
	-c 'lua vim.wait(3000, function() return not require("conform").formatting(0) end)' >/dev/null || true

a_content="$(cat "$fA")"
b_content="$(cat "$fB")"
rm -f "$fA" "$fB"

assert_contains "$a_content" "def  f( x )" "buffer A: vim.b.autoformat=false did not block format"
assert_contains "$b_content" "def g(y):" "buffer B: inherited global autoformat did not format"
