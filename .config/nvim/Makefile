# Phase 5 test harness (D-27..D-32). Recipes use tabs (Makefile syntax + CLAUDE.md).
# Lua spec runner is the v1.1 default; bash baselines retained until Phase 9 PARITY-01.

MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: test test-bash test-spec test-all

test:
	cd $(MAKEFILE_DIR) && nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/spec/ {minimal_init = 'tests/minimal_init.lua', sequential = true}"

test-bash:
	cd $(MAKEFILE_DIR) && tests/startup/run.sh

test-spec:
	cd $(MAKEFILE_DIR) && nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedFile $(FILE)"

test-all: test test-bash
