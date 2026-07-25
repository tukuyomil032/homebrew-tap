cask "perch@latest" do
  version "0.3.0-beta-5"
  sha256 "90409c1bde30a2b94d6a6a7e0746c1b821463967736335a180724104b5ccff6f"

  url "https://github.com/tukuyomil032/Perch/releases/download/v#{version}/perch-#{version}.dmg"
  name "Perch"
  desc "Dynamic Island-style live hub for macOS — Now Playing, AI usage, and more"
  homepage "https://github.com/tukuyomil032/Perch"

  livecheck do
    url "https://github.com/tukuyomil032/Perch"
    # Matches both tag forms Perch has shipped: v0.3.0-beta-5 from the old
    # hand-tagged flow and v0.3.1-beta.6 from the current release workflow.
    regex(/^v?(\d+(?:\.\d+)+(?:[.-]beta[.-]\d+)?)$/i)
    # The default :github_releases path drops every pre-release, which is the
    # opposite of what this cask tracks, so the JSON is filtered here instead.
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.nil?

        match[1]
      end
    end
  end

  conflicts_with cask: "perch"
  depends_on macos: :sonoma

  app "perch.app"

  zap trash: [
    "~/Library/Application Support/com.tukuyomi032.perch",
    "~/Library/Caches/com.tukuyomi032.perch",
    "~/Library/Preferences/com.tukuyomi032.perch.plist",
  ]

  caveats <<~EOS
    perch@latest follows the newest release, pre-releases included.
    Expect beta-quality builds; switch to the perch cask once a stable
    release is available.

    perch is not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click perch.app > Open > Open.

    perch runs as a menubar/overlay app.
    Launch perch.app after installation — it will appear in the menu bar.
  EOS
end
