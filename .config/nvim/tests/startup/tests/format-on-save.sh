#!/usr/bin/env bash
# Test SC-1 / FORMAT-01: :w on a bad-formatted python file triggers conform format_on_save.
# Expected: FAIL against current HEAD (conform.lua has no format_on_save key); GREEN after Plan 02-02.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

tmpfile="$(mktemp --suffix=.py)"
printf 'def  f( x ):return x+1\n' > "$tmpfile"

nvim_headless \
	-c "edit $tmpfile" \
	-c 'write' \
	-c 'lua vim.wait(3000, function() return not require("conform").formatting(0) end)' >/dev/null || true

actual="$(cat "$tmpfile")"
rm -f "$tmpfile"

assert_contains "$actual" "def f(x):" "format-on-save did not run black on BufWritePre"
