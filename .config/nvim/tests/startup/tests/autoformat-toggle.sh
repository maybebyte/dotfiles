#!/usr/bin/env bash
# Test SC-2 / FORMAT-02: vim.g.autoformat=false suppresses format-on-save globally;
# toggling it back on restores formatting. Dual-save design ensures the test fails
# against current HEAD (no format-on-save at all → control save also unchanged).
# Expected: FAIL against current HEAD (no vim.g.autoformat gating); GREEN after Plan 02-02.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

fOff="$(mktemp --suffix=.py)"
fOn="$(mktemp --suffix=.py)"
printf 'def  f( x ):return x+1\n' > "$fOff"
printf 'def  g( y ):return y+2\n' > "$fOn"

nvim_headless \
	-c "edit $fOff" \
	-c 'lua vim.g.autoformat = false' \
	-c 'write' \
	-c 'lua vim.wait(3000, function() return not require("conform").formatting(0) end)' \
	-c "edit $fOn" \
	-c 'lua vim.g.autoformat = true' \
	-c 'write' \
	-c 'lua vim.wait(3000, function() return not require("conform").formatting(0) end)' >/dev/null || true

off_content="$(cat "$fOff")"
on_content="$(cat "$fOn")"
rm -f "$fOff" "$fOn"

# When autoformat=false, save must NOT format.
assert_contains "$off_content" "def  f( x )" "global autoformat=false was still formatted"
# When autoformat=true (control), save MUST format — proves the test is exercising the gate
# rather than passing trivially because no format-on-save exists at all.
assert_contains "$on_content" "def g(y):" "global autoformat=true did not trigger format-on-save (control save)"
