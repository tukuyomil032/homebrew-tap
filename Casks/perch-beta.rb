cask "perch-beta" do
  arch arm: "arm64", intel: "x86_64"
  version "0.0.0"
  sha256 arm:   "0000000000000000000000000000000000000000000000000000000000000000",
         intel: "0000000000000000000000000000000000000000000000000000000000000000"

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