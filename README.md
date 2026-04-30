<h1 align="center">Poppy</h1>

<p align="center">
  <em>A de-cloudified fork of Warp — no accounts, no telemetry, no servers.</em>
</p>

<p align="center">
  <a href="#installation">Install</a>
  ·
  <a href="#what-this-is">What this is</a>
  ·
  <a href="#whats-different-from-upstream-warp">What's different</a>
  ·
  <a href="#building">Build</a>
  ·
  <a href="#license">License</a>
</p>

---

## What this is

Poppy is a community fork of [Warp](https://github.com/warpdotdev/warp), the agentic terminal that Warp Inc. open-sourced in 2026. It is to Warp what [VSCodium](https://github.com/VSCodium/vscodium) is to VS Code: the **same source, same UI, same UX**, but with the parts that phone home to a vendor's cloud removed or stubbed.

The goal is a drop-in terminal you can install instead of Warp's official build and use offline, without an account, without telemetry, and without a hosted backend in the loop. Local features stay; cloud features either run against your own keys or no-op cleanly.

> [!NOTE]
> Poppy is early. The first published artifacts are placeholder installers (`v0.1.0-stub`) so the install/uninstall flow can be exercised end-to-end before the full client lands. Treat it as pre-alpha.

## What's different from upstream Warp

| Area | Upstream Warp | Poppy |
|---|---|---|
| Telemetry / crash reporting | Sentry + custom events | Disabled at build time (`crash_reporting` feature off) |
| Account / sign-in | Required for cloud features | Stubbed (in progress) |
| Cloud agents (Oz, hosted models) | Backed by Warp servers | Local-only; bring-your-own-key models |
| Auto-update | Pulls from Warp's CDN | Disabled (download new releases manually) |
| Branding | Warp / Warp Drive | Poppy |
| Source license | AGPL-3.0 (app) + MIT (UI crates) | **Unchanged.** AGPL-3.0 (app) + MIT (UI crates) |

What we deliberately keep:

- The full WarpUI rendering layer
- The agent harness (so you can run Claude Code, Codex, Gemini CLI, etc. inside Poppy)
- All terminal UX: blocks, command palette, themes, AI suggestions, settings schema
- Settings + theme files at their existing paths so an in-place swap over a Warp install picks up your existing config

## Installation

### Windows

Download the latest installer from the [releases page](https://github.com/yanimeziani/poppy/releases) and run it.

- `Poppy-Setup-x64-stub.exe` — Intel/AMD 64-bit, Windows 10 1903+ / Windows 11
- `Poppy-Setup-arm64-stub.exe` — ARM64, Windows 10 1903+ / Windows 11

The installer drops `poppy.exe` at `C:\Program Files\Poppy\` and registers an uninstaller. To swap over an existing Warp install, see [`docs/poppy/install-target.md`](docs/poppy/install-target.md) for the snapshot/rollback procedure.

### macOS / Linux

Not yet packaged. The codebase builds on macOS and Linux upstream; bundling for those platforms in Poppy is on the roadmap.

## Building

Poppy builds via GitHub Actions on `windows-latest`. Local builds are unsupported today: a release build of the workspace OOM-kills with less than ~16 GB RAM (a constraint that exists upstream too).

To produce an installer yourself, fork this repo and run the **Build Poppy (Windows)** workflow from the Actions tab — or just push to `master` on your fork. The workflow is in [`.github/workflows/build-windows.yml`](.github/workflows/build-windows.yml). Output:

- `poppy-windows-arm64-binary` — the bare `poppy.exe`
- `poppy-windows-arm64-installer` — the Inno Setup installer

For deeper engineering notes (cargo profiles, feature flags, bundling internals), see [`POPPY.md`](POPPY.md).

## License

Poppy is a fork. **Upstream copyright and license terms are preserved exactly as they appear in [LICENSE-AGPL](LICENSE-AGPL) and [LICENSE-MIT](LICENSE-MIT).** No re-licensing — Denver Technologies, Inc. holds the copyright on the upstream code.

| Component | License | Copyright |
|---|---|---|
| Warp client app (most crates) | [AGPL v3](LICENSE-AGPL) | © 2020-2026 Denver Technologies, Inc. |
| WarpUI framework (`warpui_core`, `warpui`) | [MIT](LICENSE-MIT) | © 2020-2026 Denver Technologies, Inc. |
| Modifications by Poppy contributors | Same as the file they modify | © 2026 Poppy contributors |

Distributing Poppy or a derivative requires the same source-availability obligations the AGPL imposes on Warp itself. See [NOTICE](NOTICE) for the third-party attribution Poppy adds on top.

## Acknowledgements

Poppy exists because Warp Inc. open-sourced their client. Every line of UX, every block, every animation, every keymap — that's their work. Poppy strips the cloud surface and renames the binary; it does not reinvent the terminal.

If you want the cloud-integrated experience (hosted agents, Drive sync, team features), use the [official Warp client](https://www.warp.dev/download) instead.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). The flow is intentionally lighter than upstream — no spec PRs required, no Oz reviewer; just open an issue or PR.

## Security

Found a vulnerability? Don't file a public issue. See [SECURITY.md](SECURITY.md).
