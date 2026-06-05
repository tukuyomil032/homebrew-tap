cask "perch-beta" do
  arch arm: "arm64", intel: "x86_64"
  version "0.3.0-beta-1"
  sha256 arm:   "bf8d66f5fdb4bba1a55b19ea1fcfa96171b721075fd3a2d48b055ca636652465",
         intel: "9bd3bb04ade3d11b5d0bc91e7b2ba25c1310d92ed8871753411075d1a5b66c22"

  url "https://github.com/tukuyomil032/Perch/releases/download/v#{version}/perch-#{version}-#{arch}.dmg"
  name "Perch Beta"
  desc "Dynamic Island-style live hub for macOS — beta channel"
  homepage "https://github.com/tukuyomil032/Perch"

  depends_on macos: ">= :sonoma"

  app "perch-beta.app"

  zap trash: [
    "~/Library/Application Support/com.tukuyomi032.perch",
    "~/Library/Caches/com.tukuyomi032.perch",
    "~/Library/Preferences/com.tukuyomi032.perch.plist",
  ]

  caveats <<~EOS
    perch-beta is not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click perch-beta.app > Open > Open.

    perch-beta runs as a menubar/overlay app.
    Launch perch-beta.app after installation — it will appear in the menu bar.
  EOS
end
