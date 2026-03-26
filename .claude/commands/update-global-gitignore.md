---
name: update-global-gitignore
description: Workflow command scaffold for update-global-gitignore in dotfiles.
allowed_tools: ["Bash", "Read", "Write", "Grep", "Glob"]
---

# /update-global-gitignore

Use this workflow when working on **update-global-gitignore** in `dotfiles`.

## Goal

Incrementally add new patterns to the global gitignore file for various tools, languages, or file types.

## Common Files

- `.config/git/ignore`

## Suggested Sequence

1. Understand the current state and failure mode before editing.
2. Make the smallest coherent change that satisfies the workflow goal.
3. Run the most relevant verification for touched files.
4. Summarize what changed and what still needs review.

## Typical Commit Signals

- Edit .config/git/ignore to add new ignore patterns.
- Commit the changes with a message describing the new patterns added.

## Notes

- Treat this as a scaffold, not a hard-coded script.
- Update the command if the workflow evolves materially.