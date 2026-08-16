cask 'mc-vector' do
  arch arm: 'aarch64', intel: 'x64'
  version "2.0.58"
  sha256 arm:   "c2a46e375473ac307b756e5a11f203ecbc53d6306545f09b13c04f3c9794c031",
         intel: "2a4f90e7a2794a4871d6dc8f216a40a35811f40fd6f5b85b293b8287b591de21"

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
