cask "glance" do
  arch arm: "arm64", intel: "x86_64"

  version "1.02"
  sha256 arm:   "c96e9250d6379247e549a3af2d45f8059f5b765aa3ae1230bcd37f82589928b8",
         intel: "3e76fbac95a7681f27876c2ea7acad405643838d7fa18f6ab2aeb459ecc2c457"

  url "https://github.com/tukuyomil032/Glance/releases/download/v#{version}/glance-#{version}-#{arch}.dmg"
  name "glance"
  desc "Quick Look extension for rendered Markdown previews"
  homepage "https://github.com/tukuyomil032/Glance"

  livecheck do
    url "https://github.com/tukuyomil032/Glance"
    strategy :github_latest
  end

  depends_on macos: ">= :tahoe"

  app "glance.app"

  zap trash: [
    "~/Library/Application Support/com.tukuyomi032.glance",
    "~/Library/Caches/com.tukuyomi032.glance",
    "~/Library/Group Containers/group.com.tukuyomi032.glance",
    "~/Library/Preferences/com.tukuyomi032.glance.plist",
  ]

  caveats <<~EOS
    After installing glance:
      1. Launch glance.app once to register the Quick Look extension.
      2. Enable glance in System Settings > Privacy & Security > Extensions > Quick Look.
      3. Run `qlmanage -r` if Finder does not pick up the extension.

    glance is not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click glance.app > Open > Open.
  EOS
end
