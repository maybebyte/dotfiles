#!/usr/bin/env bash
# Shared helpers for Phase 1 startup tests.
# Sourced by tests/startup/run.sh and every tests/startup/tests/*.sh.

NVIM_BIN="${NVIM_BIN:-nvim}"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"
BASELINE_FILE="$NVIM_CONFIG_DIR/.planning/phases/01-startup-init-hygiene/baseline-startuptime.txt"

# Run headless nvim with a list of -c commands; prints combined stdout+stderr.
nvim_headless() {
	"$NVIM_BIN" --headless "$@" -c 'qa!' 2>&1
}

# Print lazy.nvim's LazyDone time in milliseconds for the current config.
# Note: require("lazy").stats().startuptime is set on UIEnter which does not
# fire in headless mode. We use times.LazyDone as the headless proxy instead.
nvim_startuptime_ms() {
	nvim_headless -c 'lua local s = require("lazy").stats(); io.write(tostring(s.times and (s.times.LazyDone or 0) or 0))' | tr -d '[:space:]'
}

# Compare two values for string equality.
# Convention: when one side is a known-expected reference, pass it as $1;
# when both sides are runtime values (e.g. before/after measurements),
# the label "expected/actual" in the failure message is advisory only —
# callers should use $msg to document the semantic role of each side.
assert_eq() {
	local expected="$1" actual="$2" msg="${3:-}"
	if [ "$expected" != "$actual" ]; then
		echo "assertion failed: $msg (expected=$expected actual=$actual)" >&2
		return 1
	fi
}

assert_contains() {
	local haystack="$1" needle="$2" msg="${3:-}"
	case "$haystack" in
		*"$needle"*) return 0 ;;
		*) echo "assertion failed: $msg (missing '$needle' in output)" >&2; return 1 ;;
	esac
}

assert_not_contains() {
	local haystack="$1" needle="$2" msg="${3:-}"
	case "$haystack" in
		*"$needle"*) echo "assertion failed: $msg (found '$needle' in output)" >&2; return 1 ;;
		*) return 0 ;;
	esac
}
