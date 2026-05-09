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
