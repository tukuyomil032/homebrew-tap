class Gitkeeper < Formula
  desc "Safe Git branch cleanup tool -- detects merged, stale, and upstream-gone branches"
  homepage "https://github.com/tukuyomil032/GitKeeper"
  url "https://github.com/tukuyomil032/GitKeeper/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "e1b7ee157163203bea94e13e97d6cda5325b9c87d98cf59a738207d80fb46450"
  version "0.0.22"
  license "MIT"

  depends_on "jq"
  depends_on "fzf"

  livecheck do
    url "https://github.com/tukuyomil032/GitKeeper"
    strategy :github_latest
  end

  def install
    # Install lib/ and version.env alongside the script in libexec so BASE_DIR resolves correctly
    libexec.install "lib"
    libexec.install "version.env"
    libexec.install "bin/gitkeeper"
    bin.install_symlink libexec / "gitkeeper"
    bin.install_symlink libexec / "gitkeeper" => "gk"

    zsh_completion.install "completions/_gitkeeper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitkeeper --version")
    assert_match version.to_s, shell_output("#{bin}/gk --version")
  end
end
