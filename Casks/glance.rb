cask "glance" do
  arch arm: "arm64", intel: "x86_64"
  version "1.04"
  sha256 arm:   "b8affe65cb9e961772530e583598163bfd18ad1e29d8bc5088b9a1205c47a613",
         intel: "8cbc102b76db54ebc7678c20a8b69477dcb6c8737643b9eb4486f9dfc58f62f6"

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
