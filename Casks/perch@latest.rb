cask "perch@latest" do
  version "0.3.1-beta.7"
  sha256 "4fbc269598b2d94af12625442879ac483d89165ad126ee2488538d4769ef6c2c"

  url "https://github.com/tukuyomil032/Perch/releases/download/v#{version}/perch-#{version}.dmg"
  name "Perch"
  desc "Dynamic Island-style live hub for macOS — Now Playing, AI usage, and more"
  homepage "https://github.com/tukuyomil032/Perch"

  livecheck do
    url "https://github.com/tukuyomil032/Perch"
    # Upstream Perch only publishes stable and beta channels (see
    # scripts/resolve-release.py, which accepts only those two channel
    # names), so alpha and rc tags never exist. This regex intentionally
    # targets plain tags and beta tags only, and matches both beta forms
    # Perch has shipped: v0.3.0-beta-5 from the old hand-tagged flow and
    # v0.3.1-beta.6 from the current release workflow.
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
    perch@latest follows the newest release, including beta pre-releases
    (tags matching vX.Y.Z or vX.Y.Z-beta.N).
    Expect beta-quality builds; switch to the perch cask once a stable
    release is available.

    perch is not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click perch.app > Open > Open.

    perch runs as a menubar/overlay app.
    Launch perch.app after installation — it will appear in the menu bar.
  EOS
end
