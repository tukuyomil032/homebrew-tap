cask 'glance' do
  arch arm: 'arm64', intel: 'x86_64'

  version '1.0'
  sha256 arm: 'd50265d49278dc46a9f362f6eed770847dd71d15ad6f35e6f4bb2681cd4e0d28',
         intel: 'e9a2e7ada85961502c51458d644ad5fd7a479bac1d7bef576b576eeed27020bf'

  url "https://github.com/tukuyomil032/Glance/releases/download/v#{version}/glance-#{version}-#{arch}.dmg"
  name 'glance'
  desc 'Quick Look extension for rendered Markdown previews'
  homepage 'https://github.com/tukuyomil032/Glance'

  livecheck do
    url 'https://github.com/tukuyomil032/Glance'
    strategy :github_latest
  end

  depends_on macos: '>= :tahoe'

  app 'glance.app'

  zap trash: [
    '~/Library/Application Support/com.tukuyomi032.glance',
    '~/Library/Caches/com.tukuyomi032.glance',
    '~/Library/Group Containers/group.com.tukuyomi032.glance',
    '~/Library/Preferences/com.tukuyomi032.glance.plist'
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
