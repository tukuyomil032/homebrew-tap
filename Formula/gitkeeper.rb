class Gitkeeper < Formula
  desc "Safe Git branch cleanup tool -- detects merged, stale, and upstream-gone branches"
  homepage "https://github.com/tukuyomil032/GitKeeper"
  url "https://github.com/tukuyomil032/GitKeeper/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "fcd55ffee452df6e91cf8954bddb909adff852f268898739a1ec5d510e4e2aa1"
  version "0.0.21"
  license "MIT"

  depends_on "jq"
  depends_on "fzf"

  livecheck do
    url "https://github.com/tukuyomil032/GitKeeper"
    strategy :github_latest
  end

  def install
    # Install lib/ and VERSION alongside the script in libexec so BASE_DIR resolves correctly
    libexec.install "lib"
    libexec.install "VERSION"
    libexec.install "bin/gitkeeper"
    bin.install_symlink libexec / "gitkeeper"

    zsh_completion.install "completions/_gitkeeper"
  end

  test do
    assert_match "0.0.21", shell_output("#{bin}/gitkeeper --version")
  end
end
