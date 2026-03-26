```markdown
# dotfiles Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill teaches you how to contribute to and maintain a TypeScript-based dotfiles repository with a focus on Neovim configuration, global gitignore management, and related documentation. You'll learn the coding conventions, commit patterns, and step-by-step workflows for updating editor plugins, keybindings, automation commands, and documentation. The guide also provides suggested commands to streamline common tasks.

## Coding Conventions

- **File Naming:**  
  Use `camelCase` for file names.  
  _Example:_  
  ```
  myPluginConfig.ts
  keybindingsInit.ts
  ```

- **Import Style:**  
  Use **relative imports**.  
  _Example:_  
  ```typescript
  import { myFunction } from './utils/myFunction';
  ```

- **Export Style:**  
  Use **named exports**.  
  _Example:_  
  ```typescript
  export function myFunction() { ... }
  export const MY_CONST = 42;
  ```

- **Commit Messages:**  
  Follow **conventional commit** format.  
  Prefixes: `feat`, `fix`, `chore`, `refactor`, `docs`, `perf`  
  _Example:_  
  ```
  feat(nvim): add telescope plugin config
  fix(gitignore): ignore .DS_Store files globally
  ```

## Workflows

### Update Global Gitignore

**Trigger:** When you want to ignore new file types or tools globally in all git projects.  
**Command:** `/add-gitignore-pattern`

1. Edit `.config/git/ignore` to add new ignore patterns.
2. Commit the changes with a message describing the new patterns added.

_Example:_
```
# Ignore macOS system files
.DS_Store
```

### Add or Update Neovim Plugin Config

**Trigger:** When you want to install, configure, or update a Neovim plugin.  
**Command:** `/add-nvim-plugin`

1. Create or update a plugin config file in `.config/nvim/lua/my/plugins/*.lua`.
2. Optionally update `.config/nvim/README.md` to document the plugin or its keybindings.
3. Optionally update related keybindings in `.config/nvim/lua/my/keybindings/init.lua`.

_Example:_
```lua
-- .config/nvim/lua/my/plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  config = function()
    require('telescope').setup{}
  end
}
```

### Add or Update Neovim Keybindings

**Trigger:** When you want to introduce or change Neovim keybindings for improved workflow.  
**Command:** `/add-nvim-keybinding`

1. Edit `.config/nvim/lua/my/keybindings/init.lua` to add or modify keybindings.
2. Optionally update `.config/nvim/README.md` to document the new or changed keybindings.

_Example:_
```lua
-- .config/nvim/lua/my/keybindings/init.lua
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true })
```

### Add or Update Neovim Autocmds

**Trigger:** When you want to automate editor actions or fix issues related to events in Neovim.  
**Command:** `/add-nvim-autocmd`

1. Edit `.config/nvim/lua/my/autocmds/init.lua` to add or update autocmds.
2. Commit with a message describing the new automation or fix.

_Example:_
```lua
-- .config/nvim/lua/my/autocmds/init.lua
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = ':%s/\\s\\+$//e'
})
```

### Add or Update Neovim Documentation

**Trigger:** When you want to document new features, plugins, or usage instructions for your Neovim setup.  
**Command:** `/update-nvim-docs`

1. Edit or create documentation files such as `.config/nvim/README.md`, `.config/nvim/AGENTS.md`, or `.config/nvim/CLAUDE.md`.
2. Commit with a message summarizing the documentation changes.

_Example:_
```
# .config/nvim/README.md
## Plugins
- Telescope: Fuzzy file finder. Trigger with `<leader>ff`.
```

### Update or Refactor Neovim Plugin Configs

**Trigger:** When you want to modernize, refactor, or synchronize plugin config patterns across several plugins.  
**Command:** `/refactor-nvim-plugins`

1. Edit multiple files in `.config/nvim/lua/my/plugins/*.lua` to apply the refactor or update.
2. Commit with a message summarizing the refactor or update.

_Example:_
```lua
-- Before
require('plugin').setup({ ... })

-- After (standardized)
return {
  'author/plugin',
  config = function()
    require('plugin').setup({ ... })
  end
}
```

## Testing Patterns

- **Test File Pattern:**  
  Test files are named with the pattern `*.test.*`.

- **Testing Framework:**  
  The specific testing framework is unknown, but tests are colocated with source files and follow the `.test.` naming convention.

_Example:_
```
utils.test.ts
```

## Commands

| Command                | Purpose                                                      |
|------------------------|--------------------------------------------------------------|
| /add-gitignore-pattern | Add new patterns to the global gitignore file                |
| /add-nvim-plugin       | Add or update a Neovim plugin configuration                  |
| /add-nvim-keybinding   | Add or modify Neovim keybindings                            |
| /add-nvim-autocmd      | Add or update Neovim autocmds                               |
| /update-nvim-docs      | Add or update Neovim documentation                          |
| /refactor-nvim-plugins | Refactor or update multiple Neovim plugin configuration files|
```
