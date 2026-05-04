---
phase: 07-fresh-nvim-spec-ports
plan: "02"
subsystem: testing
tags: [plenary, lsp, yaml, inlay-hints, capability-guard, spec]

requires:
  - phase: 07-fresh-nvim-spec-ports
    plan: "01"
    provides: H.assert_no_lua_error helper in tests/spec/helpers.lua

provides:
  - PORT-14 inlay hint capability guard spec (yamlls negative path)

affects: [07-03-inlay-hints-attach, future LSP capability guard specs]

tech-stack:
  added: []
  patterns:
    - "Mason-bin PATH prepend: vim.env.PATH = mason_bin .. ':' .. vim.env.PATH at module level so vim.fn.executable() resolves mason-managed servers in plenary host process"
    - "D-15 hard-fail via assert.equals(1, vim.fn.executable()) — no pending(), no skip"
    - "D-18 H.assert_no_lua_error as load-bearing regression catch (not is_enabled==false)"

key-files:
  created:
    - tests/spec/inlay_hints_cap_guard_spec.lua
  modified: []

key-decisions:
  - "Mason-bin PATH deviation: prepend ~/.local/share/nvim/mason/bin to PATH so vim.fn.executable('yaml-language-server') resolves (Mason bin not in shell PATH by default)"
  - "D-15: hard-fail via assert.equals(1, vim.fn.executable()) confirmed working with Mason-bin fix"
  - "D-18: H.assert_no_lua_error is the load-bearing assertion — yamlls is_enabled==false is true pre/post impl regardless; traceback sniff catches future supports_method() throws"
  - "D-25: profile-delta carve-out confirmed — 14 PASS + 1 FAIL (profile-delta only) accepted"

requirements-completed: [PORT-14]

duration: ~20min
completed: 2026-05-03
---

# Phase 07 Plan 02: PORT-14 inlay hint capability guard spec (yamlls negative)

**Single-it() plenary spec asserting yamlls does NOT enable inlay hints — H.assert_no_lua_error is the load-bearing regression catch**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-05-03
- **Completed:** 2026-05-03
- **Tasks:** 2 (create spec + commit gate)
- **Files modified:** 1

## Accomplishments

- Created `tests/spec/inlay_hints_cap_guard_spec.lua` with single `describe` + single `it()` block (D-13)
- D-14: H.nvim_child timeout = 8000ms (3s LSP-attach wait + slack)
- D-15: hard-fail assertion `assert.equals(1, vim.fn.executable("yaml-language-server"))` with Mason-bin PATH prepend deviation (see Deviations)
- D-18 LOAD-BEARING: `H.assert_no_lua_error(r)` after H.nvim_child call — catches future `supports_method()` throws
- D-20: inline stdout last-line extraction `r.stdout:match("([^\n]+)%s*$")`
- D-21: explicit `"+qa!"` terminator in args
- Pitfall 2: `vim.fn.rename(p, yaml_path)` for `.yaml` ft detection
- Gate: `make test` 0 failures (14 spec files); `tests/startup/run.sh` 14 PASS + 1 FAIL (profile-delta only, D-25 carve-out)
- D-02 sequential gate confirmed: feat(07-01) present in git log before this commit

## Task Commits

1. **feat(07-02): port PORT-14 inlay hint cap guard spec (yamlls negative)** - `10ff1b7`

## Parity Table

| Bash file | Bash assertion count | Lua spec | Lua assertion count | Parity |
|-----------|---------------------|----------|---------------------|--------|
| tests/startup/tests/inlay-hints-cap-guard.sh | 1 effective (`assert_eq "false" "$last"`) + 1 implicit error sniff (grep E5108/stack traceback) | tests/spec/inlay_hints_cap_guard_spec.lua | 1 (`assert.equals("false", last, ...)`) — H.assert_no_lua_error is the codified error sniff (D-18) | OK |

(`assert.equals(0, r.exit)` and the executable() hard-fail are scaffolding/precondition guards, not parity-counted.)

## Test Gate Output

```
make test — 14 spec files, 0 failures
inlay_hints_cap_guard_spec.lua: Success: 1, Failed: 0, Errors: 0

tests/startup/run.sh:
PASS=14, FAIL=1 (profile-delta only — D-25 carve-out)
GATE PASSED
```

## Files Created/Modified

- `tests/spec/inlay_hints_cap_guard_spec.lua` — PORT-14 yamlls negative capability guard spec

## Decisions Honored

| Decision | Status |
|----------|--------|
| D-04: per-spec commit gate | Honored — make test green + bash run.sh 14 PASS before commit |
| D-13: single describe + single it() | Honored |
| D-14: H.nvim_child timeout = 8000ms | Honored |
| D-15: hard-fail on missing yaml-language-server | Honored (with Mason-bin deviation — see below) |
| D-18: H.assert_no_lua_error after H.nvim_child | Honored — LOAD-BEARING |
| D-20: stdout last-line extraction inline | Honored |
| D-21: explicit +qa! terminator | Honored |
| D-22: top-of-file parity comment | Honored |
| D-25: profile-delta carve-out | Honored — 14 PASS + 1 FAIL (profile-delta) accepted |
| D-27: no helpers.lua / minimal_init.lua / lua/my/** changes | Honored |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Mason bin not in PATH for plenary test host — vim.fn.executable() returned 0**

- **Found during:** Task 1 spec verification (`make test-spec` first run)
- **Issue:** `yaml-language-server` is installed at `~/.local/share/nvim/mason/bin/yaml-language-server` but that directory is not in the shell PATH when plenary-busted runs. `vim.fn.executable("yaml-language-server")` returned 0, causing the D-15 hard-fail assertion to trigger immediately.
- **Fix:** Added Mason-bin PATH prepend at module level (before `describe`), mirroring bash `have_server()` which checks both `command -v` and `$MASON_BIN/<name>`:
  ```lua
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
  if vim.fn.isdirectory(mason_bin) == 1 then
      vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
  end
  ```
  This also propagates to H.nvim_child subprocess since `H.nvim_child` passes `PATH = vim.env.PATH` to the child env. ASVS: `isdirectory` guard prevents no-op prepend on clean installs without Mason.
- **Files modified:** `tests/spec/inlay_hints_cap_guard_spec.lua`
- **Commit:** `10ff1b7`

## D-02 Sequential Gate Confirmation

`git log --oneline` confirms `feat(07-01)` (`2db24d5`) is present before `feat(07-02)` (`10ff1b7`). D-02 sequential gate held.

## Known Stubs

None — spec asserts real subprocess behavior (H.nvim_child boots full user config; yamlls auto-attaches; is_enabled == "false" is the live result).

## Threat Flags

None — no new network endpoints, auth paths, file access patterns, or schema changes introduced. T-07-04 (LSP attach hang) mitigated by D-14 8000ms timeout + explicit `+qa!`. T-07-05 (tempfile suffix leak) mitigated by `vim.fn.delete(yaml_path)`. T-07-06 (env exfiltration) mitigated by H.nvim_child's `clear_env=true` + 3-key whitelist.

## Self-Check: PASSED

- `tests/spec/inlay_hints_cap_guard_spec.lua` — FOUND
- Commit `10ff1b7` — FOUND in git log
- `make test` exit 0 — CONFIRMED
- `tests/startup/run.sh` 14 PASS + 1 FAIL (profile-delta) — CONFIRMED

---
*Phase: 07-fresh-nvim-spec-ports*
*Completed: 2026-05-03*
