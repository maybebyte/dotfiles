#!/usr/bin/env bash
# Dispatcher for Phase 1 startup tests.
# Usage:
#   tests/startup/run.sh                 # run all tests
#   tests/startup/run.sh --test NAME     # run one named test
#   tests/startup/run.sh --quick         # run fast subset (skip profile-delta)
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

TESTS_DIR="$SCRIPT_DIR/tests"
QUICK_SKIP=(profile-delta)

run_one() {
	local name="$1"
	local path="$TESTS_DIR/${name}.sh"
	if [ ! -x "$path" ]; then
		echo "FAIL  $name  (missing or non-executable: $path)"
		return 1
	fi
	if "$path"; then
		echo "PASS  $name"
		return 0
	else
		echo "FAIL  $name"
		return 1
	fi
}

mode="all"
target=""
case "${1:-}" in
	--test)
		mode="one"
		target="${2:-}"
		[ -n "$target" ] || { echo "usage: $0 --test NAME" >&2; exit 2; }
		;;
	--quick) mode="quick" ;;
	"") mode="all" ;;
	*) echo "unknown arg: $1" >&2; exit 2 ;;
esac

if [ "$mode" = "one" ]; then
	run_one "$target"
	exit $?
fi

failed=0
for f in "$TESTS_DIR"/*.sh; do
	[ -e "$f" ] || continue
	name="$(basename "$f" .sh)"
	if [ "$mode" = "quick" ]; then
		skip=0
		for s in "${QUICK_SKIP[@]}"; do
			[ "$s" = "$name" ] && skip=1 && break
		done
		[ "$skip" = 1 ] && continue
	fi
	run_one "$name" || failed=$((failed+1))
done

if [ "$failed" -ne 0 ]; then
	echo ""
	echo "$failed test(s) failed"
	exit 1
fi
echo ""
echo "All tests passed"
