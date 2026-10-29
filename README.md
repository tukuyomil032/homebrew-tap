# tukuyomil032/tap

Homebrew tap and Scoop bucket for tukuyomil032's apps.

## macOS (Homebrew)

```bash
brew tap tukuyomil032/tap
```

### Available Casks

| App | Install |
|-----|---------|
| [glance](https://github.com/tukuyomil032/Glance) — Quick Look extension for rendered Markdown previews | `brew install --cask glance` |
| [Perch](https://github.com/tukuyomil032/Perch) — Dynamic Island-style live hub for macOS（stable チャンネル） | 準備中（stable リリース未公開） |
| [Perch](https://github.com/tukuyomil032/Perch) — 同上（beta チャンネル・pre-release を含む最新を追跡） | `brew install --cask perch@latest` |

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
