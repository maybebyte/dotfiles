#!/usr/bin/env bash
# Test SC-4 / LINT-01: :edit python file triggers lint on BufReadPost, before any :w.
# Expected: FAIL against current HEAD (nvim-lint ft= trigger + no BufReadPost autocmd); GREEN after Plan 02-03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

tmpfile="$(mktemp --suffix=.py)"
printf 'import os\nprint("hi")\n' > "$tmpfile"

out="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua vim.wait(500, function() return #vim.diagnostic.get(0) > 0 end)' \
	-c 'lua io.write(tostring(#vim.diagnostic.get(0)))')"
rm -f "$tmpfile"

if [ "$out" = "0" ] || [ -z "$out" ]; then
	echo "no diagnostics after BufReadPost — lint-on-open did not run (got '$out')" >&2
	exit 1
fi
