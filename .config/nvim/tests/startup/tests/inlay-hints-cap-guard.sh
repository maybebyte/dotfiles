#!/usr/bin/env bash
# Test LSP-02 / D-24 / D-21 negative: a server without inlayHintProvider
# must NOT enable inlay hints — no error, no visual glitch.
# Uses yamlls (no inlayHintProvider per RESEARCH §Which Servers).
# SLOW: ~3s LSP wait. Added to QUICK_SKIP.
#
# TDD note: This test is green both pre-impl AND post-impl — yamlls never
# advertises inlayHintProvider so is_enabled stays false regardless of
# whether Plan 02's LspAttach callback exists. The test's value is
# REGRESSION PREVENTION post-impl: the Lua-error sniff catches any future
# change that makes the supports_method guard throw.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

MASON_BIN="${MASON_BIN:-$HOME/.local/share/nvim/mason/bin}"

have_server() {
	local name="$1"
	command -v "$name" >/dev/null 2>&1 && return 0
	[ -x "$MASON_BIN/$name" ] && return 0
	return 1
}

if ! have_server yaml-language-server; then
	echo "SKIP: yaml-language-server not installed"
	exit 0
fi

tmpfile="$(mktemp --suffix=.yaml)"
trap 'rm -f "$tmpfile"' EXIT
printf 'foo: bar\nbaz:\n  - one\n  - two\n' > "$tmpfile"

# Wait for ANY client to attach (yamlls will), then probe is_enabled.
# is_enabled({bufnr=0}) should stay false because LspAttach callback's
# supports_method("textDocument/inlayHint") returns false for yamlls.
out="$(nvim_headless \
	-c "edit $tmpfile" \
	-c 'lua vim.wait(3000, function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end)' \
	-c 'lua io.write(tostring(vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })))')"

last="$(printf '%s\n' "$out" | tail -n 1 | tr -d '[:space:]')"

# Also verify no Lua error traceback in stderr (D-21: "no error").
if printf '%s\n' "$out" | grep -qE '(E5108|stack traceback|attempt to call|attempt to index)'; then
	echo "Lua error in LspAttach path — capability guard allowed an error through:" >&2
	printf '%s\n' "$out" >&2
	exit 1
fi

assert_eq "false" "$last" "inlay hints NOT enabled for yamlls (no inlayHintProvider)"
