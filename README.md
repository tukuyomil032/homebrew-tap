# tukuyomil032/tap

Homebrew tap and Scoop bucket for tukuyomil032's apps.

## macOS (Homebrew)

```bash
brew tap tukuyomil032/tap
```

### Available Casks

| App | Install |
|-----|---------|
| [MC-Vector](https://github.com/tukuyomil032/MC-Vector) — Minecraft server management desktop app | `brew install --cask mc-vector` |
| [glance](https://github.com/tukuyomil032/Glance) — Quick Look extension for rendered Markdown previews | `brew install --cask glance` |
| [Perch](https://github.com/tukuyomil032/Perch) — Dynamic Island-style live hub for macOS（stable チャンネル） | 準備中（stable リリース未公開） |
| [Perch](https://github.com/tukuyomil032/Perch) — 同上（beta チャンネル・beta を含む最新を追跡） | `brew install --cask perch@latest` |

### Uninstall

```bash
brew uninstall <app>
brew untap tukuyomil032/tap  # すべてのアプリをアンインストール後
```

## Windows (Scoop)

```powershell
scoop bucket add tukuyomil032 https://github.com/tukuyomil032/homebrew-tap
```

### Available Apps

| App | Install |
|-----|---------|
| [MC-Vector](https://github.com/tukuyomil032/MC-Vector) — Minecraft server management desktop app | `scoop install mc-vector` |

### Uninstall

```powershell
scoop uninstall <app>
scoop bucket rm tukuyomil032  # すべてのアプリをアンインストール後
```

## Note

MC-Vector is ad-hoc signed (not notarized by Apple).
If macOS Gatekeeper blocks the app on first launch, right-click `MC-Vector.app` → Open → Open anyway.

glance is not notarized by Apple.
After installing, launch `glance.app` once, enable it in System Settings → Privacy & Security → Extensions → Quick Look, then run `qlmanage -r` if Finder does not pick it up.

Perch has two channels. `perch` follows stable releases and `perch@latest` follows the newest release including beta pre-releases, mirroring how Homebrew ships `claude-code` and `claude-code@latest`. Perch only publishes `stable` and `beta` (no `alpha` or `rc` tags exist), so `perch@latest` matches only `vX.Y.Z` and `vX.Y.Z-beta.N`. Perch has not published a stable release yet, so **use `perch@latest` for now** — `perch` cannot be installed until the first stable release ships. The two casks install the same `perch.app` and are therefore mutually exclusive.

Perch is not notarized by Apple.
If macOS Gatekeeper blocks it on first launch, right-click `perch.app` → Open → Open. Perch runs as a menubar/overlay app — launch it after installation to see it in the menu bar.
