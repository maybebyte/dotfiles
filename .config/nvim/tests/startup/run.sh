#!/usr/bin/env bash
# PORT-15 carve-out: single-test runner for tests/startup/tests/profile-delta.sh.
# Phase 9 (PARITY-02) deleted the 14 in-process / fresh-nvim bash specs; their
# Lua ports under tests/spec/ are the source of truth. profile-delta.sh remains
# under PORT-15 because Qubes triple-nested spawn noise pushed the Lua port's
# min-of-5 measurement +28.95 ms over the baseline (sticky pending in v1.1).
# See .planning/phases/08-performance-spec/08-01-SUMMARY.md for the rationale.
#
# Usage: tests/startup/run.sh --test profile-delta
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# shellcheck source=lib.sh
source "$SCRIPT_DIR/lib.sh"

TESTS_DIR="$SCRIPT_DIR/tests"

run_one() {
	local name="$1"
	local path="$TESTS_DIR/${name}.sh"
	if [ ! -x "$path" ]; then
		# Usage error (typo in test name / wrong path) — distinct exit code
		# from a real test failure (1) so callers can tell them apart.
		echo "ERROR $name  (missing or non-executable: $path)" >&2
		return 2
	fi
	# Buffer combined stdout+stderr so PASS/FAIL summary lines stay clean.
	local output rc
	output="$("$path" 2>&1)"
	rc=$?
	if [ "$rc" -eq 0 ]; then
		[ -n "$output" ] && printf '%s\n' "$output"
		echo "PASS  $name"
		return 0
	else
		printf '%s\n' "$output" >&2
		echo "FAIL  $name"
		return 1
	fi
}

case "${1:-}" in
	--test)
		target="${2:-}"
		[ -n "$target" ] || { echo "usage: $0 --test profile-delta" >&2; exit 2; }
		run_one "$target"
		exit $?
		;;
	*)
		echo "usage: $0 --test profile-delta" >&2
		exit 2
		;;
esac
