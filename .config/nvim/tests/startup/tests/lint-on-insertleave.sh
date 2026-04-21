#!/usr/bin/env bash
# Test SC-5 / LINT-03: InsertLeave in a non-lua linted ft (python) triggers lint.
# Expected: FAIL against current HEAD (FileType/InsertLeave autocmd only matches pattern={"lua"}); GREEN after Plan 02-03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

tmpfile="$(mktemp --suffix=.py)"
printf 'x = 1\n' > "$tmpfile"

out="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua vim.api.nvim_feedkeys("i" .. "import foo\n" .. vim.keycode("<Esc>"), "xt", false)' \
	-c 'lua vim.wait(500, function() return #vim.diagnostic.get(0) > 0 end)' \
	-c 'lua io.write(tostring(#vim.diagnostic.get(0)))')"
rm -f "$tmpfile"

if [ "$out" = "0" ] || [ -z "$out" ]; then
	echo "InsertLeave did not trigger lint on python ft (got '$out')" >&2
	exit 1
fi
