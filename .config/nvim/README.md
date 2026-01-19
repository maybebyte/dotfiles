# Neovim Configuration

Modular Lua configuration with lazy.nvim, LSP, Treesitter, and intelligent completion.

## Table of Contents

- [Features](#features)
- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Plugins by Category](#plugins-by-category)
- [Key Bindings](#key-bindings)
- [Customization Guide](#customization-guide)
- [External Tools](#external-tools)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## Features

- **lazy.nvim** plugin management with network timeout handling (10-second timeout prevents indefinite blocking)
- **Full LSP support** via nvim-lspconfig + Mason v2
- **Intelligent completion** with nvim-cmp and GitHub Copilot integration
- **Treesitter** syntax highlighting, textobjects, and context display
- **Debugging** with nvim-dap + Telescope integration
- **Telescope** fuzzy finding with extensive keybindings
- **Git integration** with fugitive and gitsigns (loads only in git repositories)
- **Catppuccin** theme with transparency support
- **Lazy loading** for fast startup (verify with `:Lazy profile`)
- **Persistent undo** history across sessions
- **Modeline disabled** for security (`vim.opt.modeline = false`)
- **Notable autocommands**: yank highlighting, ZenMode for help files, auto-reload Xresources/Xdefaults

## Quick Start

```bash
# 1. Clone the bare dotfiles repository
git clone --bare https://github.com/maybebyte/dotfiles "$HOME/.dotfiles"

# 2. Checkout files into $HOME
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout

# 3. Open Neovim (plugins install automatically, 10s network timeout)
nvim
```

After Neovim opens, verify the installation:

```vim
:checkhealth
```

## Prerequisites

### Required

| Dependency | Purpose |
|------------|---------|
| Neovim 0.11+ | Required for `vim.o.winborder` feature; 0.10+ minimum for `vim.uv` |
| Git | Plugin installation and version control |
| Ripgrep (`rg`) | Telescope live grep functionality |
| Nerd Font | Icons via nvim-web-devicons |
| `gmake` | Building telescope-fzf-native (all platforms) |
| `timeout` | GNU coreutils command used in lazy.nvim bootstrap |

### Optional

| Dependency | Purpose |
|------------|---------|
| Node.js | GitHub Copilot |
| GitHub Copilot subscription | AI-powered code completion (authenticate via `:Copilot auth`) |
| Formatters/Linters | See [External Tools](#external-tools) |

### XDG Base Directory Support

This configuration uses XDG Base Directory Specification with fallbacks:

| Variable | Default |
|----------|---------|
| `XDG_CONFIG_HOME` | `~/.config` |
| `XDG_DATA_HOME` | `~/.local/share` |
| `XDG_STATE_HOME` | `~/.local/state` |

## Installation

This Neovim configuration is part of a full dotfiles repository. Checkout will place files throughout `$HOME`, including shell configurations. Back up existing dotfiles first.

### Bare Repository Setup

```bash
# Clone as bare repository
git clone --bare https://github.com/maybebyte/dotfiles "$HOME/.dotfiles"

# Checkout files into $HOME
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

**Note:** If checkout fails due to existing files, back up or remove the conflicting files and retry.

### Post-Checkout Configuration

Hide untracked files to prevent `git status` from showing everything in `$HOME`:

```bash
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
```

### Convenience Alias

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
```

Reload your shell or run `source ~/.bashrc` (or `~/.zshrc`) to use the alias.

### First Run

On first launch, lazy.nvim bootstraps automatically with a 10-second network timeout. The colorscheme (Catppuccin) is pre-loaded before lazy.nvim to ensure the theme is available during the plugin installation UI.

If the network is unavailable or slow, Neovim starts without plugins and displays a warning.

### Verification

```vim
:checkhealth
```

## Directory Structure

```
~/.config/nvim/
├── init.lua                      # Bootstrap, colorscheme loading
├── lazy-lock.json                # Plugin version lock file
└── lua/
    └── my/
        ├── settings/
        │   ├── init.lua          # Loads vim_env → vim_opt → vim_g
        │   ├── vim_env.lua       # XDG environment variables
        │   ├── vim_opt.lua       # Vim options (backup, display, etc.)
        │   └── vim_g.lua         # Leader keys, GPG config (customize this!)
        ├── keybindings/
        │   └── init.lua          # Global keybinds, ;/: swap
        ├── autocmds/
        │   └── init.lua          # Autocommands (yank highlight, ZenMode, etc.)
        ├── plugins/              # Plugin configurations (one file per plugin/group)
        │   ├── lspconfig.lua
        │   ├── telescope.lua
        │   ├── nvim-cmp.lua
        │   └── ...
        └── completion_utils.lua  # Shared completion configuration
```

> **Important**: `vim_g.lua` contains personal settings including Qubes OS-specific GPG wrapper paths. Customize or remove vim-gnupg integration for your system.

## Plugins by Category

Plugins verified against `lazy-lock.json`. Transitive dependencies (plenary.nvim, nui.nvim, nvim-nio, etc.) are excluded.

### Core

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybinding hints |
| [vim-sleuth](https://github.com/tpope/vim-sleuth) | Auto-detect indentation |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | QoL utilities (terminal, bigfile, quickfile) |

### LSP

| Plugin | Purpose |
|--------|---------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) v2.* | LSP/DAP/Linter installer |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) v2.* | Mason + lspconfig bridge |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim Lua development |
| [lspkind.nvim](https://github.com/onsails/lspkind.nvim) | LSP completion icons |
| [nvim-lightbulb](https://github.com/kosayoda/nvim-lightbulb) | Code action indicator |

### Linting

| Plugin | Purpose |
|--------|---------|
| [nvim-lint](https://github.com/mfussenegger/nvim-lint) | Async linting (Go, Lua, HTML, Markdown, Python) |

### Completion

| Plugin | Purpose |
|--------|---------|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Completion engine |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua) | GitHub Copilot integration |
| [copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) | Copilot as cmp source |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippet engine |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Snippet collection |
| cmp-buffer, cmp-cmdline, cmp-nvim-lsp, cmp-nvim-lua, cmp-path, cmp_luasnip, cmp-dap | Completion sources |

### AI

| Plugin | Purpose |
|--------|---------|
| [claudecode.nvim](https://github.com/coder/claudecode.nvim) | Claude Code terminal integration |

### Treesitter

| Plugin | Purpose |
|--------|---------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Syntax-aware text objects |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky context header |

### Navigation

| Plugin | Purpose |
|--------|---------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) v0.2.0 | Fuzzy finder |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | FZF sorter (requires gmake) |
| [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim) | Telescope as vim.ui.select |
| [telescope-dap.nvim](https://github.com/nvim-telescope/telescope-dap.nvim) | DAP integration |
| [flash.nvim](https://github.com/folke/flash.nvim) | Enhanced motions |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | Quick file navigation |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | File explorer as buffer |

### Git

| Plugin | Purpose |
|--------|---------|
| [vim-fugitive](https://github.com/tpope/vim-fugitive) | Git commands |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs in gutter |
| [vim-rhubarb](https://github.com/tpope/vim-rhubarb) | GitHub integration |

### UI

| Plugin | Purpose |
|--------|---------|
| [catppuccin](https://github.com/catppuccin/nvim) | Colorscheme |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics list |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | File icons |

### Editing

| Plugin | Purpose |
|--------|---------|
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround text objects |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Toggle comments |
| [mini.align](https://github.com/echasnovski/mini.align) | Text alignment |

### Debugging

| Plugin | Purpose |
|--------|---------|
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) v0.10.0 | Debug Adapter Protocol |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) v4.0.0 | DAP UI |
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Inline debug values |
| [mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim) v2.5.2 | Mason DAP integration |

### Notes & Documentation

| Plugin | Purpose |
|--------|---------|
| [neorg](https://github.com/nvim-neorg/neorg) v9.3.0 | Note-taking (workspace: `~/neorg`) |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODO/FIXME/etc. |
| [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim) | Markdown table of contents |

### Other

| Plugin | Purpose |
|--------|---------|
| [undotree](https://github.com/mbbill/undotree) | Undo history visualization |
| [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) | Distraction-free editing |
| [vim-gnupg](https://github.com/jamessan/vim-gnupg) | GPG file encryption |

## Key Bindings

- **Leader key**: `<Space>`
- **Local leader**: `,`
- **Important**: `;` and `:` are swapped (pinky protection)

Press `<leader>` and wait for which-key to show available bindings.

<details>
<summary><strong>Navigation & Flash</strong></summary>

| Key | Mode | Description |
|-----|------|-------------|
| `j` / `k` | n, x | Smart navigation (visual lines without count, actual lines with count) |
| `n` / `N` | n | Search navigation (n always forward, N always backward, opens folds) |
| `s` | n, x, o | Flash jump |
| `gs` | n, x, o | Flash Treesitter |
| `r` | o | Remote Flash |
| `R` | o, x | Treesitter Search |
| `<C-s>` | c | Toggle Flash Search |
| `-` | n | Oil: open parent directory |
| `<M-x>` | n (Oil) | Oil: open file in horizontal split |
| `<M-r>` | n (Oil) | Oil: refresh buffer |
| `<C-h/j/k/l>` | n | Window navigation |
| `<M-h>` | n, t | Smart resize left (shrinks at left edge, grows otherwise) |
| `<M-j>` | n, t | Smart resize down (shrinks at bottom edge, grows otherwise) |
| `<M-k>` | n, t | Smart resize up (shrinks at top edge, grows otherwise) |
| `<M-l>` | n, t | Smart resize right (shrinks at right edge, grows otherwise) |

</details>

<details>
<summary><strong>Telescope</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>sf` | Find files |
| `<leader>ts` | Telescope builtin picker |
| `<leader>gf` | Git files |
| `<leader>/` | Current buffer fuzzy find |
| `<leader>s.` | Recent files |
| `<leader>sn` | Search nvim config |
| `<leader>sr` | Resume last search |
| `<leader><leader>` | Open buffers |
| `<leader>sh` | Help tags |
| `<leader>sw` | Grep word |
| `<leader>sg` | Live grep |
| `<leader>sd` | Diagnostics |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |

</details>

<details>
<summary><strong>Telescope DAP</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>dtb` | List breakpoints |
| `<leader>dtc` | DAP commands |
| `<leader>dtf` | Stack frames |

</details>

<details>
<summary><strong>Harpoon</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>haf` | Add file |
| `<leader>hqm` | Quick menu |
| `<leader>h1-4` | Jump to file 1-4 |
| `<leader>hn` | Next file |
| `<leader>hp` | Previous file |

</details>

<details>
<summary><strong>LSP</strong></summary>

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gI` | n | Go to implementation (Telescope) |
| `K` | n | Hover documentation |
| `gr` | n | References (Telescope) |
| `<leader>vrn` | n | Rename symbol |
| `<leader>vca` | n | Code action |
| `<leader>vws` | n | Workspace symbols |
| `<leader>vrr` | n | Find all references |
| `<leader>vf` | n | Format buffer |
| `<C-h>` | i | Signature help |
| `[d` / `]d` | n | Previous/next diagnostic |
| `]e` / `[e` | n | Next/previous error |
| `]w` / `[w` | n | Next/previous warning |
| `<leader>vd` | n | Diagnostic float |

</details>

<details>
<summary><strong>Git</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>gp` | Previous hunk |
| `<leader>gn` | Next hunk |
| `<leader>vh` | View hunk |

</details>

<details>
<summary><strong>Debugging</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>dc` | Continue |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>di` | Step into |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dC` | Run to cursor |
| `<leader>dj` | Stack down |
| `<leader>dk` | Stack up |
| `<leader>dT` | Terminate |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression |

</details>

<details>
<summary><strong>Completion & Snippets</strong></summary>

| Key | Mode | Description |
|-----|------|-------------|
| `<C-n>` / `<C-p>` | i, s | Navigate completion |
| `<C-y>` | i, s | Confirm selection |
| `<C-Space>` | i, s | Trigger completion |
| `<C-u>` / `<C-d>` | i, s | Scroll docs |
| `<C-f>` | i, s | LuaSnip jump forward |
| `<C-b>` | i, s | LuaSnip jump back |

</details>

<details>
<summary><strong>Editing & Clipboard</strong></summary>

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>y` | n, v | Yank to system clipboard |
| `<leader>Y` | n | Yank lines to system clipboard |
| `<leader>p` | n | Paste from clipboard (after) |
| `<leader>P` | n | Paste from clipboard (before) |
| `<leader>S` | n | Substitute all |
| `<` / `>` | x | Indent and reselect |
| `J` / `K` | v | Move selection down/up |
| `<leader>dws` | n | Delete trailing whitespace |
| `<leader>dnl` | n | Delete trailing newlines |
| `<leader>frm` | n, v | Format file or range |

</details>

<details>
<summary><strong>Utility</strong></summary>

| Key | Description |
|-----|-------------|
| `<leader>L` | Toggle Lazy UI |
| `<leader>M` | Toggle Mason UI |
| `<leader>o` | Toggle spell check |
| `<leader>fm` | Open NetRW file manager |
| `<Esc>` | Clear search highlights |

</details>

<details>
<summary><strong>Terminal Mode</strong></summary>

| Key | Description |
|-----|-------------|
| `<C-Space>` | Toggle terminal mode |
| `<C-h>` | Exit terminal + move left |
| `<C-j>` | Exit terminal + move down |
| `<C-k>` | Exit terminal + move up |
| `<C-l>` | Exit terminal + move right |

</details>

<details>
<summary><strong>Claude Code (AI)</strong></summary>

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ac` | n | Toggle Claude terminal |
| `<leader>af` | n | Focus Claude terminal |
| `<leader>ar` | n | Resume Claude session |
| `<leader>aC` | n | Continue Claude session |
| `<leader>am` | n | Select Claude model |
| `<leader>ab` | n | Add current buffer to context |
| `<leader>as` | v | Send selection to Claude |
| `<leader>at` | n (oil) | Add file from file explorer |
| `<leader>aa` | n | Accept diff |
| `<leader>ad` | n | Deny diff |

</details>

## Customization Guide

### Adding New Plugins

Create a new file in `lua/my/plugins/`:

```lua
-- lua/my/plugins/my-plugin.lua
return {
    "author/plugin-name",
    lazy = true,
    config = function()
        require("plugin-name").setup({})
    end,
}
```

### Settings Load Order

Settings are loaded in this order via `lua/my/settings/init.lua`:

1. `vim_env.lua` - XDG environment variables
2. `vim_opt.lua` - Vim options
3. `vim_g.lua` - Global variables (leader keys, GPG config)

### Modifying Settings

| To change... | Edit... |
|--------------|---------|
| Leader key | `lua/my/settings/vim_g.lua` |
| Tab/indent | `lua/my/settings/vim_opt.lua` |
| XDG paths | `lua/my/settings/vim_env.lua` |
| Global keybinds | `lua/my/keybindings/init.lua` |
| Autocommands | `lua/my/autocmds/init.lua` |

### Changing Colorscheme

The colorscheme is pre-loaded in `init.lua` before lazy.nvim for the installation UI:

```lua
-- init.lua (around line 54)
vim.cmd("colorscheme catppuccin-frappe")
```

Also update your preferred colorscheme plugin in `lua/my/plugins/`.

### Neorg Workspace

Default workspace path is `~/neorg`. Customize in `lua/my/plugins/neorg.lua`:

```lua
["core.dirman"] = {
    config = {
        workspaces = {
            neorg = "~/neorg",  -- Change this path
        },
    },
},
```

### Important: vim_g.lua Customization

The `vim_g.lua` file contains Qubes OS-specific GPG wrapper configuration:

```lua
vim.g.GPGExecutable = vim.fn.expand("~/.local/bin/qubes-gpg-wrapper") .. " --trust-model always"
```

For non-Qubes systems, either:
- Remove these lines and disable vim-gnupg
- Change the path to your GPG executable (typically just `"gpg"`)

## External Tools

<details>
<summary><strong>Required</strong></summary>

| Tool | Purpose |
|------|---------|
| `gmake` | Building telescope-fzf-native |

</details>

<details>
<summary><strong>Formatters (conform.nvim)</strong></summary>

| Language | Formatter |
|----------|-----------|
| C | clang_format |
| CSS, HTML, JavaScript, JSON, Markdown, YAML | prettier |
| Go | gofumpt |
| Lua | stylua |
| Perl | perltidy |
| Python | black |
| Shell | shfmt |
| TeX | tex-fmt |
| XML | xmlformatter |

</details>

<details>
<summary><strong>Linters (nvim-lint)</strong></summary>

| Language | Linters |
|----------|---------|
| Go | revive |
| Lua | luacheck, selene |
| HTML | erb_lint |
| Markdown | markdownlint |
| Python | mypy, pylint, ruff |

</details>

### Installation

```vim
:MasonInstall <tool>
```

Or use your system package manager. Formatting and linting degrade gracefully if tools are missing.

## Maintenance

| Task | Command |
|------|---------|
| Update plugins | `:Lazy update` |
| Update Mason packages | `:MasonUpdate` |
| Profile startup time | `:Lazy profile` |
| Check health | `:checkhealth` |

> **Note**: Some plugins use pinned versions for stability (mason v2.*, telescope 0.2.0, nvim-dap 0.10.0). Updating may require configuration changes.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Plugins not loading | Check network; 10-second timeout requires GNU `timeout` command |
| Backup directory issues | Uses `$XDG_STATE_HOME/nvim/backup` (defaults to `~/.local/state/nvim/backup`) |
| gmake not found | Install via Homebrew/ports on BSD/macOS; on Linux, symlink: `ln -s /usr/bin/make /usr/bin/gmake` |
| timeout command not found | Install GNU coreutils, or modify `init.lua` bootstrap section |
| Git features not appearing | gitsigns only loads in git repositories (intentional) |
| GPG errors | vim-gnupg uses Qubes OS-specific wrapper by default; customize `vim_g.lua` |
| Copilot not working | Run `:Copilot auth` and ensure you have an active subscription |
| Mason tools not working | Ensure Mason bin path is in `$PATH`, or use system-installed tools |
| Help files open in ZenMode | Intentional behavior for focused reading (see `lua/my/autocmds/init.lua`) |

---

This is a personal configuration. Feel free to copy or modify any portion for your own use.
