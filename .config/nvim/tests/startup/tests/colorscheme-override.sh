#!/usr/bin/env bash
# Test CONFIG-04: Normal.bg must be NONE (transparent) on initial load and
# must survive a colorscheme swap.
# Expected: FAIL against current HEAD (overrides not autocmd-driven yet); GREEN after Plan 02.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

# Part 1: initial load — Normal.bg should be nil/NONE (transparent)
out="$(nvim_headless \
	-c 'lua local hl = vim.api.nvim_get_hl(0, { name = "Normal" }); io.write(tostring(hl.bg))')"
case "$out" in
	nil|""|NONE) : ;;
	*) echo "initial Normal.bg was $out (expected nil/NONE — transparent background)" >&2; exit 1 ;;
esac

# Part 2: override must survive a colorscheme swap
out2="$(nvim_headless \
	-c 'colorscheme habamax' \
	-c 'colorscheme catppuccin-mocha' \
	-c 'lua local hl = vim.api.nvim_get_hl(0, { name = "Normal" }); io.write(tostring(hl.bg))')"
case "$out2" in
	nil|""|NONE) : ;;
	*) echo "post-swap Normal.bg was $out2 (expected nil/NONE — override did not survive :colorscheme swap)" >&2; exit 1 ;;
esac
