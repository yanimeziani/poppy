# POPPY.md

Engineering notes for working in this repo. The original upstream `WARP.md` is preserved at the bottom for posterity (most of it still applies — Poppy is a fork, not a rewrite).

## What this repo is

A fork of [warpdotdev/warp](https://github.com/warpdotdev/warp). The fork ships:

1. The OSS channel renamed `warp-oss` → `poppy` end to end (binary name, app id, bundle metadata, channel state, autoupdate paths).
2. A minimal Windows CI workflow that bundles the `poppy` binary and packages it via Inno Setup.
3. A stub installer pipeline (`script/stub/` + `.github/workflows/release-stub.yml`) that produces a tiny placeholder `.exe` for shipping the install/uninstall flow before the full client builds.
4. Branding/docs swapped (this file, `README.md`, `CONTRIBUTING.md`, `FAQ.md`, `SECURITY.md`, the OSS channel icon).

What is **not** changed:

- `LICENSE-AGPL` and `LICENSE-MIT` — both stay as-is. Upstream Warp's copyright is preserved.
- `crates/warpui_core`, `crates/warpui` — the rendering framework keeps its name. It's MIT-licensed and useful to the broader Rust ecosystem.
- The agent harness, settings schema, theme files, key bindings — all upstream.

## Building

### CI (the supported path)

`.github/workflows/build-windows.yml` runs on `windows-latest`, builds the `poppy` binary for `aarch64-pc-windows-msvc`, and packages an Inno Setup installer.

Triggers:

- Every push to `master` (paths-ignore: `docs/**`, `**/*.md` — doc commits won't burn CI minutes).
- Manually via the **Actions** tab → **Build Poppy (Windows)** → **Run workflow**.

Artifacts:

- `poppy-windows-arm64-binary` — bare `poppy.exe`
- `poppy-windows-arm64-installer` — `Poppy-Setup-arm64.exe`

### Caching

[`Swatinem/rust-cache@v2`](https://github.com/Swatinem/rust-cache) is configured with `cache-on-failure: true`, so partial builds still populate the cache for the next run. The shared key is `poppy-oss-arm64`.

### Profile

The OSS channel uses `profile.release` (no LTO) rather than upstream's `rlto` (ThinLTO). ThinLTO costs ~30% on cold compile of the ~5000-file workspace and we don't need perf-tuned binaries for placeholder/early builds. See `script/windows/bundle.ps1`:

```powershell
} elseif ("$CHANNEL" -eq 'oss') {
    $CARGO_PROFILE = 'release'
}
```

If you want LTO for a real release, change this to `rlto` — at the cost of much longer build times.

### Features

The OSS channel build features are set in `script/windows/bundle.ps1`:

```
release_bundle, gui, nld_improvements
```

Notably absent (vs upstream Stable):

- `crash_reporting` — drops Sentry from the dep tree
- `cloud_mode`, `cloud_mode_input_v2`, etc. — drops cloud agent UI surface
- `with_local_server` — drops local-server connection plumbing

If you need to re-enable any of these, edit `bundle.ps1`. Be aware that turning `crash_reporting` back on pulls Sentry back into the build.

### Local builds

Not supported today. Upstream comments in `Cargo.toml` describe `release-lto-debug_assertions` OOM-killing release builds on CI, and our typical WSL has 7.5 GB which is well below the threshold. If you have a 32 GB+ Windows host with the toolchain installed, in theory:

```
git clone https://github.com/yanimeziani/poppy.git
cd poppy
./script/windows/bundle.ps1 -CHANNEL oss -ARCH arm64 -RELEASE_TAG 0.1.0
```

…but please file an issue if it works for you so we can document the minimum spec.

## Releasing

Two release flows ship in this repo:

### Stub installer (placeholder, both archs)

`.github/workflows/release-stub.yml` — `workflow_dispatch` only.

Builds a tiny std-only Rust source (`script/stub/poppy_stub.rs`) for both x64 and arm64, packages each through Inno Setup using `script/stub/poppy-stub-installer.iss`, and uploads both to a single GitHub Release. AppId is `poppy-terminal-oss` so the real installer (when it lands) upgrades the stub in place.

Inputs:

- `release_tag` (default: `v0.1.0-stub`)
- `publish` (default: `false` — drafts the release; set to `true` to publish immediately)

### Full installer (real binary, arm64)

`.github/workflows/build-windows.yml` — runs on every push and via dispatch. Currently uploads artifacts but doesn't auto-create a release; promote the artifact manually:

```bash
gh run download <run-id> --repo yanimeziani/poppy
gh release create v0.1.0 \
  poppy-windows-arm64-installer/Poppy-Setup-arm64.exe \
  poppy-windows-arm64-binary/poppy.exe \
  --title "Poppy v0.1.0" \
  --repo yanimeziani/poppy
```

A future improvement: combine these into one workflow that runs the build and creates a draft release if the version tag is new.

## Layout

The fork lives at the repo root, not in a subdirectory:

```
.
├── app/                   # the binary crate (poppy + dev/stable/preview/integration)
├── crates/                # ~150 internal crates
├── script/
│   ├── windows/           # Windows bundling (bundle.ps1, windows-installer.iss)
│   └── stub/              # stub installer (poppy_stub.rs, poppy-stub-installer.iss)
├── docs/poppy/            # fork-specific docs (install-target.md, etc.)
├── .github/workflows/     # build-windows.yml, release-stub.yml only — upstream CI removed
└── ...                    # upstream layout otherwise
```

The upstream `.github/` infrastructure (issue templates, docubot, release pipelines, repo-sync) was removed because it's specific to Warp Inc.'s internal flows.

## Working upstream

Upstream is configured as the `upstream` git remote:

```
$ git remote -v
origin    https://github.com/yanimeziani/poppy.git (fork)
upstream  https://github.com/warpdotdev/warp.git
```

To pull in upstream changes:

```
git fetch upstream
git merge upstream/master
# resolve conflicts (mostly in app/Cargo.toml + bundle.ps1 around the rebrand)
```

Be deliberate: upstream lands changes at high velocity, and pulling everything is rarely the right call. Cherry-pick fixes you want; let new cloud features stay upstream.

## Things to know

- **Path-ignored CI for docs**: `docs/**` and `**/*.md` are in the workflow's `paths-ignore`, so doc commits don't trigger builds. Take advantage of this: doc PRs land instantly.
- **No `cargo` locally**: deliberately. This repo is CI-only on the Windows side.
- **No identity in `git config`**: per house convention. Pass identity inline: `git -c user.name="..." -c user.email="..." commit ...`.
- **Stub release `AppId` matches the real one**: `poppy-terminal-oss`. The stub and real installer share an AppId so installing the real installer over a stub upgrades in place rather than producing two side-by-side entries in Add/Remove Programs.

---

*The original upstream `WARP.md` engineering guide — full coding style, testing rules, presubmit details — was renamed to this file. Most of it still applies; the divergent points are called out above.*
