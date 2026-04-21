#!/usr/bin/env bash
# Test CONFIG-02: re-sourcing init.lua must not duplicate autocmds.
# Sources init.lua twice in a single headless session, counts autocmds in the
# my_highlight_overrides augroup before and after second source, asserts equal.
# Expected: FAIL against current HEAD (no guard yet); GREEN after Plan 01.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

out="$(nvim_headless \
	-c 'source $MYVIMRC' \
	-c 'lua _G.__n1 = #vim.api.nvim_get_autocmds({ group = "my_highlight_overrides" })' \
	-c 'source $MYVIMRC' \
	-c 'lua io.write(tostring(_G.__n1)..","..tostring(#vim.api.nvim_get_autocmds({ group = "my_highlight_overrides" })))')"
n1="${out%%,*}"
n2="${out##*,}"
assert_eq "$n1" "$n2" "re-sourcing duplicated autocmds in my_highlight_overrides"
