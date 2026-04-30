# Poppy FAQ

## What is Poppy?

A community fork of [Warp](https://github.com/warpdotdev/warp), the agentic terminal Warp Inc. open-sourced in 2026. Poppy is to Warp what [VSCodium](https://github.com/VSCodium/vscodium) is to VS Code: same source, same UX, vendor cloud surface stripped.

## Why does this exist?

Warp is a great terminal that's tightly integrated with a hosted backend — sign-in, telemetry, hosted AI agents, Drive sync. For users who want the UX without the cloud (privacy-conscious devs, air-gapped environments, offline workflows), there wasn't a build that just… didn't phone home. Poppy is that build.

## Is Poppy supported by Warp Inc.?

No. Poppy is an unofficial fork. We're not affiliated with Warp Inc. and we don't speak for them. If you have problems with the **official** Warp client, file with [warpdotdev/warp](https://github.com/warpdotdev/warp). If you have problems with **Poppy specifically**, file [here](https://github.com/yanimeziani/poppy/issues).

## Can I use it as a drop-in replacement for Warp on my machine?

That's the goal. The installer drops `poppy.exe` at `C:\Program Files\Poppy\` rather than overwriting your Warp install. To swap in place over an existing Warp install, see [`docs/poppy/install-target.md`](docs/poppy/install-target.md) — it covers the snapshot/rollback procedure.

Settings, themes, and SQLite data live at `%LOCALAPPDATA%\warp\Warp\` and `%APPDATA%\warp\Warp\` and are intentionally **not touched** by Poppy's installer. Your config carries over.

## What does "de-cloudified" actually mean?

It's a spectrum, and we're working through it:

- **Done:** Sentry / crash reporting compiled out (`crash_reporting` feature off in OSS builds)
- **Done:** Auto-update disabled (no calls to Warp's CDN to check for updates)
- **In progress:** Stub the auth/account flow so the client doesn't try to sign you in
- **In progress:** Replace the GraphQL client to Warp's servers with a no-op layer
- **Future:** Same for Firebase auth, managed-secrets fetch, and Warp Drive sync

The goal isn't "no network ever" — it's "no network calls to Warp's servers without your explicit consent." You can still use bring-your-own-key models with Claude / OpenAI / Gemini directly.

## Will my AI agents still work?

The agent harness — the part of Warp that runs Claude Code, Codex, Gemini CLI, your own MCP servers — stays. Poppy doesn't ship Warp's hosted agent (Oz), so:

- ✅ ACP-compatible agents you bring with API keys
- ✅ Claude Code, Codex, Gemini CLI run as external processes inside the terminal
- ❌ Warp's hosted agent mode (the "ask Warp to fix this" experience that runs server-side)

## Will my settings, themes, and aliases carry over?

Yes. Poppy reads from the same `%APPDATA%\warp\Warp\` (config) and `%LOCALAPPDATA%\warp\Warp\` (cache + data) paths upstream uses. Don't be surprised by the path name — it's intentional, so a Warp → Poppy swap is seamless.

## How do I build Poppy?

`./script/windows/bundle.ps1 -CHANNEL oss -ARCH arm64` on a windows-latest box, or — easier — push to your fork and let GitHub Actions do it. See [POPPY.md](POPPY.md).

Local builds aren't supported because the workspace OOM-kills under ~16 GB RAM. Even Warp's own CI has comments about this.

## Is Poppy stable?

No. We tag stub releases (`v0.1.0-stub`) until the full client compiles cleanly with the cloud crates stripped. Don't run it on a machine where a crash matters.

## Is Poppy legal?

Yes. Warp Inc. shipped the source under [AGPL-3.0](LICENSE-AGPL) (and [MIT](LICENSE-MIT) for the UI framework crates). AGPL specifically permits forks; what it requires is that derivatives stay open. Poppy preserves the original copyright (Denver Technologies, Inc.) on every file we didn't write, and contributes back-compatible changes under the same licenses.

## Can I redistribute Poppy?

Yes, under the terms of AGPL-3.0 / MIT — same as upstream. Don't strip the LICENSE files or pretend you wrote it.

## Where can I get help?

- [Issues](https://github.com/yanimeziani/poppy/issues) for Poppy-specific bugs
- [Upstream issues](https://github.com/warpdotdev/warp/issues) for behavior that's the same in official Warp
- The [Warp docs](https://docs.warp.dev/) for using the underlying terminal — most of it applies to Poppy too
