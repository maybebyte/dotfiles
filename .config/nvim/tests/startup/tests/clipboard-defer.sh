#!/usr/bin/env bash
# Test CONFIG-05: clipboard must be empty pre-VeryLazy.
# The save-clear-restore pattern forces vim.opt.clipboard="" at init time
# so the xsel/xclip provider probe is deferred to VeryLazy.
# If clipboard was never set in settings, this test is a no-op (empty is expected).
# Expected: FAIL against current HEAD if settings sets clipboard eagerly; GREEN after Plan 03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

out="$(nvim_headless \
	-c 'lua io.write(table.concat(vim.opt.clipboard:get(), ","))')"
if [ -n "$out" ]; then
	echo "clipboard was non-empty pre-VeryLazy: $out" >&2
	exit 1
fi
