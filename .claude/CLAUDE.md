# Memory Storage Preference

**Always call muninn_guide at the start of each session** to learn best practices for the vault.

When asked to remember something — or when the user shares any preference, fact,
decision, or instruction worth remembering — **always use MuninnDB (muninn) MCP**.
Never use local auto memory. MuninnDB is the canonical memory system.

- **Store**: `mcp__muninn__muninn_remember` (vault, concept, content)
- **Recall**: `mcp__muninn__muninn_recall` (vault, context)
- **Read**: `mcp__muninn__muninn_read` (vault, id)
- **Link**: `mcp__muninn__muninn_link` (vault, source_id, target_id)
- **Guide**: `mcp__muninn__muninn_guide` — call this on first connect to learn best practices
- **Batch**: `mcp__muninn__muninn_remember_batch` (vault, memories[])

Use vault "default" unless the user specifies otherwise. Be proactive — if the user
shares something personal or important, store it without being asked.

---

## Code Exploration Policy

Always use jCodemunch-MCP tools for code navigation. Never fall back to Read, Grep, Glob, or Bash for code exploration.

**Start any session:**
1. `resolve_repo { "path": "." }` — confirm the project is indexed. If not: `index_folder { "path": "." }`
2. `suggest_queries` — when the repo is unfamiliar

**Finding code:**
- symbol by name → `search_symbols` (add `kind=`, `language=`, `file_pattern=` to narrow)
- string, comment, config value → `search_text` (supports regex, `context_lines`)
- database columns (dbt/SQLMesh) → `search_columns`

**Reading code:**
- before opening any file → `get_file_outline` first
- one or more symbols → `get_symbol_source` (single ID → flat object; array → batch)
- symbol + its imports → `get_context_bundle`
- specific line range only → `get_file_content` (last resort)

**Repo structure:**
- `get_repo_outline` → dirs, languages, symbol counts
- `get_file_tree` → file layout, filter with `path_prefix`

**Relationships & impact:**
- what imports this file → `find_importers`
- where is this name used → `find_references`
- is this dead code → `check_references`
- file dependency graph → `get_dependency_graph`
- what breaks if I change X → `get_blast_radius`
- class hierarchy → `get_class_hierarchy`
- related symbols → `get_related_symbols`
- diff two snapshots → `get_symbol_diff`

**After editing a file:** `index_file { "path": "/abs/path/to/file" }` to keep the index fresh.

---

**Always use context7 when I need code generation, setup or configuration
steps, or library/API documentation**. This means you should automatically
use the Context7 MCP tools to resolve library id and get library docs
without me having to explicitly ask.

---

## Qubes OS Split GPG

This system uses Qubes OS with split GPG (`qubes-gpg-client-wrapper`).
Git commits require GPG signing, which needs AF_UNIX socket access to
the GPG vault qube via qrexec. The Claude Code sandbox blocks
`socket(AF_UNIX)` at the seccomp level — no `allowUnixSockets` setting
can fix this.

**Always use `dangerouslyDisableSandbox: true` when running `git commit`
commands.** The user has `skipDangerousModePermissionPrompt: true` and
`Bash:*` auto-allowed, so this runs without prompting.
