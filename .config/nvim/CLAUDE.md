# Neovim Configuration

Modular Lua config: lazy.nvim, LSP (Mason v2), nvim-cmp, treesitter, conform, nvim-lint.

Neovim 0.11+.

## Commands

```
:Lazy profile           Profile startup time
:checkhealth            Verify installation
:LspInfo                Check LSP status (use :LspLog if not attaching)
:ConformInfo            Check formatters (skips missing silently)
:MasonInstall <tool>    Install LSP/formatter/linter
NVIM_CMP_DEBUG=1 nvim   Debug completion issues
```

**Git:** This config is in a bare dotfiles repo. For all git operations on `~/.config/nvim/`:
`git --git-dir=$HOME/.dotfiles --work-tree=$HOME <command>`

## Boundaries

### ALWAYS

- Run `:checkhealth` after LSP or plugin changes
- Add `desc` field to all keymaps
- Use `pcall()` for optional dependencies
- Create new plugins as separate files in `lua/my/plugins/`
- Follow existing lazy-loading patterns (event, ft, keys, cmd)
- Update keybinds in README.md when adding, removing, or changing keybinds
- Update "Plugins by Category" in README.md when adding new plugins

### REQUIRES APPROVAL

- Adding new LSP servers to lspconfig.lua
- Modifying global keybindings in keybindings/init.lua
- Changes to completion source priority in completion.lua
- New autocommands in autocmds/init.lua
- Changes to completion_utils.lua (shared by multiple plugins)
- Changes to GPG configuration in vim_g.lua (Qubes OS-specific)

### NEVER

- Modify `lazy-lock.json` directly (use :Lazy commands)
- Modify `.claude/` directories (any location)
- Enable modelines (security risk, intentionally disabled)
- Create plugin files outside `lua/my/plugins/`
- Use Vimscript (all config is .lua)
- Use spaces for indentation
- Add plugins without lazy-loading configuration
- Use `vim.api.nvim_set_keymap()` (deprecated)
- Change version-pinned plugins without approval:
  - Mason v2.x, LuaSnip 2.x (others track branch HEAD)

## Conventions

**Plugin Pattern:**

```lua
-- DO: opts = {} calls setup() automatically
return {
    "author/plugin",
    event = "BufReadPost",
    opts = {},
}

-- DO: config only when you need more than setup()
return {
    "author/plugin",
    ft = "lua",
    config = function()
        require("plugin").setup({ option = true })
        vim.keymap.set("n", "<leader>x", ...)  -- extra setup
    end,
}
-- DON'T: return { "author/plugin" }  -- no lazy trigger
```

**Keymap Pattern:**

```lua
-- Modern API with description
vim.keymap.set("n", "<leader>sf", function()
    require("telescope.builtin").find_files()
end, { desc = "[S]earch [F]iles" })
```

**Safe Requires (pattern from completion.lua):**

```lua
-- DO: Conditional behavior based on optional plugin
local luasnip_ok, luasnip = pcall(require, "luasnip")
local mapping = luasnip_ok
    and utils.get_keymappings(cmp, luasnip)
    or utils.get_keymappings_no_snippets(cmp)

-- DON'T: Crashes if plugin not installed
local luasnip = require("luasnip")
```

**Formatting:** Tabs (tabstop=4, shiftwidth=4), textwidth=72

## Structure

```
init.lua                     # Bootstrap only (10s network timeout)
lua/my/settings/             # vim opts, globals, env vars
lua/my/keybindings/          # Global keymaps
lua/my/autocmds/             # Autocommands
lua/my/plugins/*.lua         # One file per plugin (.lua only)
lua/my/completion_utils.lua  # Shared completion logic
```

Full documentation in README.md (do not duplicate).

## Environment

XDG-compliant paths | Leader: Space | Local leader: Comma

Qubes OS: GPG wrapper at ~/.local/bin/qubes-gpg-wrapper
