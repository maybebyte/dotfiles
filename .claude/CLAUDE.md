## Fetch up-to-date documentation with context7

Use context7 automatically (without being asked) whenever generating,
configuring, or debugging code that uses an external library, framework,
SDK, or API — not for from-scratch scripts, refactors, or general
programming. Resolve docs against the version the project pins
(lockfile, pyproject.toml, mise.toml), not latest. If context7 is
unavailable or lacks the library, fetch the upstream docs instead — via
context-mode (ctx_fetch_and_index, then ctx_search) when available so
raw pages stay out of context, else plain web tools. Only if that also
fails, proceed on trained knowledge and flag that the docs were not
consulted.

## Writing conventions

When these skills are available, they are mandatory:

- Commits → commit-message-guide
- PR descriptions → pr-descriptions
- Linear issues → writing-linear-issues (also applies when closing issues)
- Linear comments → writing-linear-comments (also applies when reading
  comments to resume, before issue state changes, before editing any
  existing comment, and at session end on any worked issue)

When closing out Linear issues, ALWAYS write a brief follow-up comment
documenting the work that we did.

## GPG signing

GPG signing stays enabled. Never pass `--no-gpg-sign` or set
`commit.gpgsign=false`; if signing fails, stop and report the error.

## VPN safety (this machine)

NEVER start the strongSwan VPN or the charon daemon (`ipsec start`,
`swanctl --initiate`, `systemctl start strongswan`, or equivalents):
the otmsoc tunnel auto-initiates when charon starts and severs this
assistant's own connection. For Azure live work, use `az`, Bastion, or
VM run-command instead — never the VPN.

## Verifying reported facts

Any number, count, or issue/PR reference in a report or summary MUST be
checked against its primary source (git log, Linear, the actual file)
before it is presented. Flag anything unevidenced rather than including
it.

## Verify state before planning

Before planning or implementing a ticket, verify current state first —
git branches, open/merged PRs, and the Linear issue — and report what is
already done vs. what remains.
