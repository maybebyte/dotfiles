---
name: add-or-update-neovim-plugin-config
description: Workflow command scaffold for add-or-update-neovim-plugin-config in dotfiles.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /add-or-update-neovim-plugin-config

Use this workflow when working on **add-or-update-neovim-plugin-config** in `dotfiles`.

## Goal

Add a new Neovim plugin configuration or update an existing plugin's settings, often accompanied by documentation or keybinding updates.

## Common Files

- `.config/nvim/lua/my/plugins/*.lua`
- `.config/nvim/README.md`
- `.config/nvim/lua/my/keybindings/init.lua`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Create or update a plugin config file in .config/nvim/lua/my/plugins/*.lua.
- Optionally update .config/nvim/README.md to document the plugin or its keybindings.
- Optionally update related keybindings in .config/nvim/lua/my/keybindings/init.lua.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.