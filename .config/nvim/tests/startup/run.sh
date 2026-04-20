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
QUICK_SKIP=(profile-delta inlay-hints-attach inlay-hints-cap-guard)

run_one() {
	local name="$1"
	local path="$TESTS_DIR/${name}.sh"
	if [ ! -x "$path" ]; then
		# Usage error (typo in test name / wrong path) — distinct exit code
		# from a real test failure (1) so callers can tell them apart.
		echo "ERROR $name  (missing or non-executable: $path)" >&2
		return 2
	fi
	# Buffer combined stdout+stderr so PASS/FAIL summary lines don't interleave
	# with each test's diagnostic output when multiple tests run. Flush the
	# buffer only on failure; passing tests stay quiet.
	local output rc
	output="$("$path" 2>&1)"
	rc=$?
	if [ "$rc" -eq 0 ]; then
		# Preserve any stdout the test produced (e.g. "ensure_installed count: 28").
		[ -n "$output" ] && printf '%s\n' "$output"
		echo "PASS  $name"
		return 0
	else
		printf '%s\n' "$output" >&2
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
