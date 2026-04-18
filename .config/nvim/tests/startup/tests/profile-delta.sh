#!/usr/bin/env bash
# Test success criterion #1: startup time must not regress vs. the Phase 1 baseline.
# Reads baseline-startuptime.txt (captured at Wave 0 pre-implementation), measures
# current LazyDone time, asserts current <= baseline.
# Expected: PASS at Wave 0 (same code); should improve after Plan 04 optimizations.
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=../lib.sh
source "$SCRIPT_DIR/../lib.sh"

if [ ! -s "$BASELINE_FILE" ]; then
	echo "baseline file missing or empty: $BASELINE_FILE" >&2
	exit 1
fi
baseline="$(cat "$BASELINE_FILE")"
current="$(nvim_startuptime_ms)"
# POSIX-safe float comparison via awk
ok="$(awk -v a="$current" -v b="$baseline" 'BEGIN{ print (a <= b) ? 1 : 0 }')"
if [ "$ok" != "1" ]; then
	echo "startup regressed: baseline=$baseline current=$current" >&2
	exit 1
fi
echo "startup delta: baseline=$baseline current=$current"
