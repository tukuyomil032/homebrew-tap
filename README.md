# homebrew-tap

Homebrew tap and Scoop bucket for [MC-Vector](https://github.com/tukuyomil032/MC-Vector) — Minecraft server management desktop app.

## macOS (Homebrew)

```bash
brew tap tukuyomil032/tap
brew install --cask mc-vector
```

### Uninstall

```bash
brew uninstall mc-vector
brew untap tukuyomil032/tap
```

## Windows (Scoop)

```powershell
scoop bucket add tap https://github.com/tukuyomil032/homebrew-tap
scoop install mc-vector
```

### Uninstall

```powershell
scoop uninstall mc-vector
scoop bucket rm tap
```

## Note

MC-Vector is ad-hoc signed (not notarized by Apple).
If macOS Gatekeeper blocks the app on first launch, right-click `MC-Vector.app` → Open → Open anyway.
