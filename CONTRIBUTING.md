# Contributing to Poppy

Thanks for helping make Poppy a usable, private terminal. This guide is short on purpose — Poppy is a small fork, not a 100-engineer product.

## How contributions work here

- **Issues are welcome.** Bug reports, feature ideas, "this works in upstream Warp but not in Poppy" — all useful.
- **PRs are welcome too.** No spec PR required, no readiness label needed.
- **Don't reintroduce cloud surface.** The whole point of Poppy is that the binary doesn't phone home. PRs that add telemetry, account flows, or hard dependencies on Warp's servers won't land. Stubs and feature flags are the right tools here.
- **Stay close to upstream.** The fewer behavioral divergences from upstream Warp, the easier it is to pull in upstream fixes. Prefer feature-gating over rewrites, and add a `// poppy:` comment near anything we changed so it's easy to find later.

## Filing a good issue

Search [existing issues](https://github.com/yanimeziani/poppy/issues) first. For bugs, include:

- Steps to reproduce
- Expected vs. actual behavior
- Poppy version (taskbar/About) and OS
- Whether the same thing happens in upstream Warp (helps us know if it's a fork-specific regression)

For features, describe the user-facing problem first; an implementation sketch is optional.

## Opening a PR

1. Branch from `master` (`yourhandle/short-description`).
2. Make the change; keep PRs focused on a single logical thing.
3. If the change touches the build or workflows, run the **Build Poppy (Windows)** action on your fork before requesting review.
4. Follow upstream code style: `cargo fmt`, no `cargo clippy --workspace --all-targets --all-features --tests -- -D warnings` failures.
5. Write a commit message that explains *why*, not just *what*.

## Building

Poppy builds via GitHub Actions on `windows-latest`. See [POPPY.md](POPPY.md) for the toolchain expectations and feature flags. Local builds aren't supported today (the workspace OOM-kills under ~16 GB RAM).

## Code of Conduct

This project follows the [Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Report violations via a private GitHub Security Advisory on this repo.

## Security

Don't file public issues for security vulnerabilities. See [SECURITY.md](SECURITY.md).

## Licensing your contributions

By contributing, you agree that your changes are licensed under the same license as the file you're modifying — [AGPL-3.0](LICENSE-AGPL) for most files, [MIT](LICENSE-MIT) for the `warpui_core` and `warpui` crates. This matches upstream's licensing and means contributions can flow upstream cleanly.
