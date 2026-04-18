#!/usr/bin/env bash
# Test CONFIG-03: init.lua must not contain os.execute calls.
# Pure static check — no nvim invocation needed.
# Expected: FAIL against current HEAD (os.execute still present); GREEN after Plan 01.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

if grep -n 'os\.execute' "$NVIM_CONFIG_DIR/init.lua" >/dev/null 2>&1; then
	echo "os.execute still present in init.lua:" >&2
	grep -n 'os\.execute' "$NVIM_CONFIG_DIR/init.lua" >&2
	exit 1
fi
