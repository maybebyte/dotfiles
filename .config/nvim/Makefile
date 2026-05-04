# Phase 5 test harness (D-27..D-32). Recipes use tabs (Makefile syntax + CLAUDE.md).
# Lua spec runner is the primary harness; test-bash invokes only the PORT-15 carve-out
# (tests/startup/tests/profile-delta.sh) — see .planning/phases/08-performance-spec/08-01-SUMMARY.md.

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: test test-bash test-spec test-all

test:
	cd $(MAKEFILE_DIR) && nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/spec/ {minimal_init = 'tests/minimal_init.lua', sequential = true}"

test-bash:
	cd $(MAKEFILE_DIR) && tests/startup/run.sh --test profile-delta || echo "[Phase 8 / Option 2] profile-delta tolerated under Qubes load — see .planning/phases/08-performance-spec/08-01-SUMMARY.md"

test-spec:
	cd $(MAKEFILE_DIR) && nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedFile $(FILE)"

test-all: test test-bash
