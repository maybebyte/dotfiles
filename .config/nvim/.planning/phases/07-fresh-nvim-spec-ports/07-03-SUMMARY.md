---
phase: 07-fresh-nvim-spec-ports
plan: "03"
subsystem: tests/spec
tags: [plenary, lsp, inlay-hints, gopls, lua_ls, port]
dependency_graph:
  requires: ["07-01", "07-02"]
  provides: ["PORT-13"]
  affects: ["tests/spec/inlay_hints_attach_spec.lua"]
tech_stack:
  added: []
  patterns:
    - "H.nvim_child subprocess (timeout=15000ms, D-12)"
    - "Mason-bin PATH prepend at module level (D-15 precondition)"
    - "Verbatim extmark probe via Lua heredoc string (D-10)"
    - "Suffix-rename + explicit cleanup (Pitfall 2)"
    - "H.assert_no_lua_error defense-in-depth (D-18)"
key_files:
  created:
    - tests/spec/inlay_hints_attach_spec.lua
  modified: []
decisions:
  - "D-09: two separate it() blocks (gopls + lua_ls) — not bash's first-available fallback"
  - "D-10: gopls extmark probe lifted verbatim from bash baseline L100-126"
  - "D-11: lua_ls type-annotated content lifted verbatim from bash baseline L43-59"
  - "D-12: H.nvim_child timeout = 15000ms for both blocks"
  - "D-15: hard-fail on missing binary via assert.equals(1, vim.fn.executable(...))"
  - "D-18: H.assert_no_lua_error after each H.nvim_child call"
  - "D-25: profile-delta FAIL in bash run.sh is an accepted carve-out"
  - "D-27: lspconfig.lua not touched — config IS the test target"
metrics:
  duration: "~25 minutes"
  completed: "2026-05-03"
  tasks_completed: 2
  files_created: 1
  files_modified: 0
---

# Phase 7 Plan 03: PORT-13 Inlay Hints Attach Spec Summary

PORT-13 inlay hints attach spec with separate gopls (extmark probe) and lua_ls (is_enabled) it() blocks, closing Phase 7.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Create tests/spec/inlay_hints_attach_spec.lua | 2c26dee | tests/spec/inlay_hints_attach_spec.lua |
| 2 | Per-spec commit gate (D-04 + D-25 carve-out) — closes Phase 7 | 2c26dee | (gate verification) |

## Parity Table

| Bash file | Bash assertion count | Lua spec | Lua assertion count | Parity |
|-----------|---------------------|----------|---------------------|--------|
| tests/startup/tests/inlay-hints-attach.sh | 2 effective (`assert_eq "true" "$last"` + extmark count check) | tests/spec/inlay_hints_attach_spec.lua | 4 (gopls executable + extmark count > 0; lua_ls executable + is_enabled == "true") | OK (Lua > bash by design — D-09) |

(`assert.equals(0, r.exit)` and `H.assert_no_lua_error` are scaffolding/defense-in-depth, not parity-counted per D-22; the executable() hard-fails are precondition guards per D-15.)

## Test Gate Results

- `make test`: All specs green (2 new PORT-13 it() blocks + all prior specs passing, 0 failed).
- `bash tests/startup/run.sh`: 14 PASS, 1 FAIL (profile-delta — D-25 carve-out accepted; baseline file missing).
- Gate: PASS (14 PASS + profile-delta-only failure satisfies D-25 condition).

## Spec Structure

`tests/spec/inlay_hints_attach_spec.lua`:
- Module-level Mason-bin PATH prepend (mirrors 07-02 pattern; gopls and lua-language-server are Mason-installed).
- Module-level `extmark_probe` Lua chunk (D-10 verbatim lift from bash baseline L100-126).
- Single `describe("PORT-13 inlay hints attach", ...)` (D-09).
- `it("gopls inlay hints attach + extmark probe", ...)`:
  - Hard-fail on missing gopls (D-15).
  - Go content with `add(1, 2)` call — produces `a:` and `b:` parameter-name hints.
  - Suffix-rename to `.go` (Pitfall 2), explicit cleanup.
  - H.nvim_child timeout=15000 (D-12), `+qa!` (D-21).
  - H.assert_no_lua_error(r) (D-18).
  - Last-line extraction (D-20); asserts `^[1-9]%d*$` (positive integer extmark count).
- `it("lua_ls inlay hints attach + is_enabled", ...)`:
  - Hard-fail on missing lua-language-server (D-15).
  - Type-annotated Lua content verbatim from bash baseline L43-59 (D-11): `---@type integer[]`, `---@param`, `---@return`.
  - Suffix-rename to `.lua` (Pitfall 2), explicit cleanup.
  - H.nvim_child timeout=15000 (D-12), `+qa!` (D-21).
  - H.assert_no_lua_error(r) (D-18).
  - Last-line extraction (D-20); `assert.equals("true", last, ...)`.

## Decisions Honored

D-04, D-09, D-10, D-11, D-12, D-15, D-18, D-20, D-21, D-22, D-23, D-25, D-27.

## D-02 Sequential Gate

07-01 (feat(07-01): a42b30b parent) and 07-02 (feat(07-02): 10ff1b7) were both committed and green at plan start. Sequential gate held.

## Phase 7 Closure

All three Phase 7 specs present and passing:
- `tests/spec/colorscheme_override_spec.lua` (PORT-12, Plan 07-01)
- `tests/spec/inlay_hints_cap_guard_spec.lua` (PORT-14, Plan 07-02)
- `tests/spec/inlay_hints_attach_spec.lua` (PORT-13, Plan 07-03)

Helper widening landed: `function M.assert_no_lua_error` in `tests/spec/helpers.lua` (D-17, Plan 07-01).

README prereq entries present: gopls, lua-language-server, yaml-language-server (D-16, Plan 07-01).

PORT-12, PORT-13, and PORT-14 all shipped. Phase 7 complete. Phase 8 unblocked.

## Commit

- `2c26dee`: feat(07-03): port PORT-13 inlay hints attach spec (gopls + lua_ls in separate it() blocks)

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

None.

## Threat Flags

None — no new network endpoints, auth paths, file access patterns, or schema changes. The subprocess boundary isolation (D-22 env whitelist + clear_env=true) is maintained as designed.

## Self-Check: PASSED

- `tests/spec/inlay_hints_attach_spec.lua` exists: FOUND
- Commit `2c26dee` exists: FOUND
- `make test` exits 0: CONFIRMED
- `bash tests/startup/run.sh` 14 PASS + 1 profile-delta FAIL: CONFIRMED (D-25 carve-out)
- Phase 7 closure: all 3 specs present, helper widening landed, README prereqs present: CONFIRMED
