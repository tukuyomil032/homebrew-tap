cask 'mc-vector' do
  arch arm: 'aarch64', intel: 'x64'
  version "2.0.59"
  sha256 arm:   "e2c282b4c01f2c1a765477159502b2f9cd37ffc498341bb2ae8d2578a5cfc1ff",
         intel: "68e46738979ce4331d73d660f01eeec39e221f56b2befb0b035b286f6fb2f4b8"

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
