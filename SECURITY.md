# Security Policy

If you've found a security vulnerability in Poppy — code that lets an attacker leak data, execute commands, or escape the terminal sandbox — please report it privately.

## How to report

**Do not file a public GitHub issue.** Either:

- Open a [private security advisory](https://github.com/yanimeziani/poppy/security/advisories/new) on this repo, or
- If the vulnerability is inherited from upstream Warp (i.e. the same code path exists in `warpdotdev/warp`), please **also** file with upstream at [security@warp.dev](mailto:security@warp.dev) so it's fixed at the source.

We'll acknowledge reports within a few days and work with you on a coordinated disclosure timeline.

## Scope

In scope:

- The `poppy` binary and any code under `app/` or `crates/` shipped with it
- The Windows installer (`Poppy-Setup-*.exe`)
- The CI workflows under `.github/workflows/` that produce release artifacts

Out of scope:

- Issues in upstream Warp that don't manifest differently in Poppy (report those at [security@warp.dev](mailto:security@warp.dev))
- Third-party dependencies (report to the upstream project)
- The Warp.dev cloud services (Poppy doesn't talk to them — that's the point)

## What gets a credit

Reporters get an entry in the release notes for the version that fixes the issue, unless they prefer to remain anonymous.
