cask "perch" do
  version "0.2.0"
  sha256 "5eb9c3f3024ceaf34b2d278e6353c2eebbe6ff1a693e42c3bc1e71b57be74f0c"

  url "https://github.com/tukuyomil032/Perch/releases/download/v#{version}/perch-#{version}.dmg"
  name "Perch"
  desc "Dynamic Island-style live hub for macOS — Now Playing, AI usage, and more"
  homepage "https://github.com/tukuyomil032/Perch"

  livecheck do
    url "https://github.com/tukuyomil032/Perch"
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "perch.app"

  zap trash: [
    "~/Library/Application Support/com.tukuyomi032.perch",
    "~/Library/Caches/com.tukuyomi032.perch",
    "~/Library/Preferences/com.tukuyomi032.perch.plist",
  ]

  caveats <<~EOS
    perch is not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click perch.app > Open > Open.

    perch runs as a menubar/overlay app.
    Launch perch.app after installation — it will appear in the menu bar.
  EOS
end
