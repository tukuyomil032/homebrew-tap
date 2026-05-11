cask "glance" do
  arch arm: "arm64", intel: "x86_64"
  version "1.03"
  sha256 arm:   "79fad43efe1bb194df7900bd40a4c2d81d4acfc782e71e1a74f91f4919297bda",
         intel: "9fa83ea043866dc2333317aa26c5b32a20eef38ae166c2062d8efd72e2d8f674"

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
