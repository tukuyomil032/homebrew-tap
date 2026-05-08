cask 'mc-vector' do
  arch arm: 'aarch64', intel: 'x64'

  version '2.0.54'
  sha256 arm: '39250a97ec7b473ad28c3279f2e3275273631c9d7c44efcaf45ff5014b4ee221',
         intel: '9843683ddcdb48e79150a846f9cbd215cd848cc08d1184e095ebb515d279f29f'

  url "https://github.com/tukuyomil032/MC-Vector/releases/download/v#{version}/MC-Vector_#{version}_#{arch}.dmg"
  name 'MC-Vector'
  desc 'Minecraft server management desktop app'
  homepage 'https://github.com/tukuyomil032/MC-Vector'

  livecheck do
    url 'https://github.com/tukuyomil032/MC-Vector'
    strategy :github_latest
  end

  auto_updates true

  app 'MC-Vector.app'

  zap trash: [
    '~/Library/Application Support/com.tukuyomi032.mcvector',
    '~/Library/Caches/com.tukuyomi032.mcvector',
    '~/Library/Logs/MC-Vector',
    '~/Library/Preferences/com.tukuyomi032.mcvector.plist'
  ]

  caveats <<~EOS
    MC-Vector is ad-hoc signed and not notarized by Apple.
    If macOS Gatekeeper blocks the app on first launch:
      right-click MC-Vector.app → Open → Open anyway.
  EOS
end
