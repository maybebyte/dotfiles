#!/usr/bin/env bash
# Test CONFIG-01: keymaps must be absent pre-VeryLazy and present post-VeryLazy.
# Uses <C-h> (window focus left) which is always registered in keybindings/init.lua.
# VeryLazy does not auto-fire in headless; we trigger it explicitly (Pitfall 5).
# Expected: FAIL against current HEAD (keymaps loaded eagerly); GREEN after Plan 03.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

# Capture pre-VeryLazy and post-VeryLazy maparg in a single -c invocation
# so we avoid leaking state through _G, which any plugin could collide with.
out="$(nvim_headless \
	-c 'lua local pre = vim.fn.maparg("<C-h>", "n"); vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" }); io.write(tostring(pre)..","..vim.fn.maparg("<C-h>", "n"))')"
pre="${out%%,*}"
post="${out#*,}"
if [ -n "$pre" ]; then
	echo "keymap <C-h> was already set pre-VeryLazy: $pre" >&2
	exit 1
fi
if [ -z "$post" ]; then
	echo "keymap <C-h> was NOT set post-VeryLazy" >&2
	exit 1
fi
