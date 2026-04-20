#!/usr/bin/env bash
# Test LSP-01 / D-22: mason-tool-installer ensure_installed list is non-empty.
# Static check — counts quoted-string entries in the plugin spec file.
# Full fresh-machine install test is manual-only (see VALIDATION.md §Manual-Only).
#
# Minimum entry count (from Plan 01 mason-name-audit.txt):
#   12 LSP servers (D-06 authoritative) + 6 guaranteed formatters
#   + 7 guaranteed linters = 25 minimum.
#   Optional uncertain names (tex-fmt, xmlformatter, erb-lint) may bring
#   total up to 28 — test accepts any count in [25, 28].
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

PLUGIN_FILE="$NVIM_CONFIG_DIR/lua/my/plugins/mason-tool-installer.lua"

if [ ! -f "$PLUGIN_FILE" ]; then
	echo "mason-tool-installer plugin spec missing: $PLUGIN_FILE" >&2
	exit 1
fi

# Count quoted-string entries at the start of an indented line (the ensure_installed
# list items). Comments are `--` prefixed so the `"[a-z]` anchor skips them.
count="$(grep -cE '^[[:space:]]*"[a-z]' "$PLUGIN_FILE" || true)"

if [ "${count:-0}" -lt 25 ]; then
	echo "ensure_installed has fewer than 25 entries (got $count)" >&2
	exit 1
fi

if [ "${count:-0}" -gt 28 ]; then
	echo "ensure_installed has more than 28 entries (got $count) — unexpected bloat" >&2
	exit 1
fi

# Spot-check D-06 authoritative LSP names are all present.
missing=0
for server in lua_ls pyright gopls bashls rust_analyzer ts_ls cssls html jsonls yamlls stylelint_lsp marksman; do
	if ! grep -qE "^[[:space:]]*\"$server\"" "$PLUGIN_FILE"; then
		echo "missing D-06 LSP server: $server" >&2
		missing=$((missing + 1))
	fi
done

if [ "$missing" -ne 0 ]; then
	echo "$missing LSP server name(s) missing from ensure_installed" >&2
	exit 1
fi

# Spot-check run_on_start and lazy=false — critical per Pitfall 1.
grep -q 'lazy = false' "$PLUGIN_FILE" || { echo "missing lazy = false (Pitfall 1)" >&2; exit 1; }
grep -q 'run_on_start = true' "$PLUGIN_FILE" || { echo "missing run_on_start = true (D-02)" >&2; exit 1; }
grep -q 'auto_update = false' "$PLUGIN_FILE" || { echo "missing auto_update = false (D-03)" >&2; exit 1; }

echo "ensure_installed count: $count"
