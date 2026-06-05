cask "perch-beta" do
  arch arm: "arm64", intel: "x86_64"
  version "0.3.0-beta-3"
  sha256 arm:   "22a4906c2245d0569777b64ea3e770c7706f12fbbd0cebd23ed7de787521ddfc",
         intel: "38f8ffe85704d6b9c88bffccd583ad543ed554b1c4e8231f8b48f0f35565cbfc"

  url "https://github.com/tukuyomil032/Perch/releases/download/v#{version}/perch-#{version}-#{arch}.dmg"
  name "Perch Beta"
  desc "Dynamic Island-style live hub for macOS — beta channel"
  homepage "https://github.com/tukuyomil032/Perch"

  depends_on macos: ">= :sonoma"

  app "perch-beta.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/perch-beta.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/com.tukuyomi032.perch",
    "~/Library/Caches/com.tukuyomi032.perch",
    "~/Library/Preferences/com.tukuyomi032.perch.plist",
  ]

  caveats <<~EOS
    perch-beta is not notarized by Apple.
    If macOS Gatekeeper blocks the app after direct DMG install:
      System Settings > Privacy & Security > "Open Anyway"
      or: xattr -dr com.apple.quarantine /Applications/perch-beta.app

    perch-beta runs as a menubar/overlay app.
    Launch perch-beta.app after installation — it will appear in the menu bar.
  EOS
end
