cask 'mc-vector' do
  arch arm: 'aarch64', intel: 'x64'
  version "2.0.56"
  sha256 arm:   "ce3392501130e7f752c58a0db7db05d654a0feef863a764e0952bf7ec3eb7908",
         intel: "913b9662159fbae67126d69aa4fe3a53cbc30be73535041105910718b6f960e9"

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
