# Existing Warp install (snapshot taken 2026-04-29)

Captured before any swap so we can roll back precisely.

## Install location (system-wide)

`C:\Program Files\Warp\` — installed via Inno Setup (`unins000.exe` is the
uninstaller). Requires admin rights to overwrite.

## Files to preserve / replace

| Path | Size | Action |
|---|---|---|
| `Warp\warp.exe` | 330 MB | **REPLACE** with `poppy.exe` (renamed back to `warp.exe` for first cut so existing shortcuts still work) |
| `Warp\dxcompiler.dll` | 22 MB | keep (DirectX shader compiler, runtime dep) |
| `Warp\dxil.dll` | 1.8 MB | keep |
| `Warp\msvcp140.dll` | 1.4 MB | keep (MSVC runtime) |
| `Warp\vcruntime140.dll` | 200 KB | keep |
| `Warp\vcruntime140_1.dll` | 58 KB | keep |
| `Warp\conpty.dll` | 108 KB | keep (Windows ConPTY) |
| `Warp\arm64\OpenConsole.exe` | 1.2 MB | keep (ARM64 ConPTY backend) |
| `Warp\bin\oz.cmd` | 71 B | keep (Oz CLI launcher) |
| `Warp\icon.ico` | 156 KB | **REPLACE** with poppy flower icon |
| `Warp\pwsh.ps1` | 68 KB | keep (PowerShell init script) |
| `Warp\resources\settings_schema.json` | 86 KB | keep |
| `Warp\resources\THIRD_PARTY_LICENSES.txt` | 1.3 MB | keep + augment with Poppy NOTICE |
| `Warp\resources\bundled\` | ? | inspect, keep |
| `Warp\unins000.exe` + `unins000.dat` + `unins000.msg` | ~4.5 MB | keep (preserves uninstall path) |

## User config locations (do NOT touch)

- `C:\Users\mezia\AppData\Local\warp\Warp\` — local cache, app data, sqlite (diesel migrations confirmed in PE)
- `C:\Users\mezia\AppData\Roaming\warp\Warp\` — config, themes

## Running processes (must be killed before swap)

- `warp.exe` PID 14824 (~555 MB RSS — main process)
- `warp.exe` PID 29320 (~84 MB RSS — likely renderer or agent subprocess)

## Backup plan

Before any overwrite:

```cmd
robocopy "C:\Program Files\Warp" "C:\Program Files\Warp.bak-20260429" /E /COPYALL
```

(robocopy preserves ACLs; `xcopy` would also work. PowerShell `Copy-Item -Recurse`
loses some metadata.)

## Rollback procedure

```cmd
:: Stop poppy if running
taskkill /F /IM warp.exe
:: Restore
robocopy "C:\Program Files\Warp.bak-20260429" "C:\Program Files\Warp" /E /COPYALL /MIR
```

`/MIR` mirrors the backup over the live dir, including deletions.

## Inno Setup uninstaller compatibility

`unins000.exe` reads `unins000.dat` to know what to remove. If we keep that file
unchanged, the user can still uninstall via Add/Remove Programs and it will pull
both Warp AND our overlaid Poppy files (because they share the install root).
This is intentional — clean uninstall path preserved.

## Tech inferred from PE strings

The shipped `warp.exe` includes these crates (from embedded panic paths):

- `regex-automata-0.4.9`
- `lazy_static-1.5.0`
- `chrono-0.4.40`
- `diesel_migrations-2.3.1` ← local SQLite database with migrations
- DirectX (dxcompiler, dxil)
- ConPTY for Windows terminal protocol

Diesel migrations means swapping in a fresh build over a populated user data dir
should still work (migrations are forward-compatible) — but if upstream changes
schema after we fork, our build could miss new migrations and break the user's
DB. **Mitigation**: pin upstream sha at fork time, sync upstream weekly,
re-test migrations.
