#!/usr/bin/env bash
# Test SC-6 / LINT-02: 3 rapid :w within 150ms triggers exactly ONE try_lint call.
# Monkey-patches require("lint").try_lint to count calls via _G.__lint_calls.
# Expected: FAIL against current HEAD (no debounce — BufWritePost autocmd calls try_lint 3 times); GREEN after Plan 02-03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

tmpfile="$(mktemp --suffix=.py)"
printf 'x = 1\n' > "$tmpfile"

raw="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua _G.__lint_calls = 0; local L = require("lint"); local orig = L.try_lint; L.try_lint = function(...) _G.__lint_calls = _G.__lint_calls + 1; return orig(...) end' \
	-c 'write | write | write' \
	-c 'lua vim.wait(400, function() return false end)' \
	-c 'lua io.write("__LINTCOUNT="..tostring(_G.__lint_calls).."__")')"
rm -f "$tmpfile"

# The :write commands above print "[file] NL written" chatter to stdout in headless mode.
# Extract just the count between our markers so the assertion compares clean integers.
out="$(printf '%s' "$raw" | sed -n 's/.*__LINTCOUNT=\([0-9]*\)__.*/\1/p')"

assert_eq "1" "$out" "debounce failed: expected 1 try_lint call for 3 rapid writes, got $out (raw=$raw)"
