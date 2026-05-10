cask "glance" do
  arch arm: "arm64", intel: "x86_64"

  version "1.01"
  sha256 arm:   "ac9d11ef976f9f755d3da190a33ca34d48dc41aac368526250a3a230307492b1",
         intel: "0a353b679375764a7ca7dd781840e7c5ce7048549de0e71647251d888827e5ca"

  url "https://github.com/tukuyomil032/Glance/releases/download/v#{version}/glance-#{version}-#{arch}.dmg" do |asset_url|
    asset_name = File.basename(asset_url)
    release = GitHub::API.open_rest("https://api.github.com/repos/tukuyomil032/Glance/releases/tags/v#{version}")
    asset = release.fetch("assets", []).find { |a| a["name"] == asset_name }
    [asset["url"], { header: ["Accept: application/octet-stream",
                              "Authorization: bearer #{GitHub::API.credentials}"] }]
  end
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
