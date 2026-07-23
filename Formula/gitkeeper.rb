class Gitkeeper < Formula
  desc "Safe Git branch cleanup tool -- detects merged, stale, and upstream-gone branches"
  homepage "https://github.com/tukuyomil032/GitKeeper"
  url "https://github.com/tukuyomil032/GitKeeper/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "19b3e2b5f9a8abccbdec45f226dee1a7049d7e32546fb6f292ddabb1fe566731"
  version "0.0.19"
  license "MIT"

  depends_on "jq"
  depends_on "fzf"

  livecheck do
    url "https://github.com/tukuyomil032/GitKeeper"
    strategy :github_latest
  end

  def install
    # Install lib/ alongside the script in libexec so BASE_DIR resolves correctly
    libexec.install "lib"
    libexec.install "bin/gitkeeper"
    bin.install_symlink libexec / "gitkeeper"

    zsh_completion.install "completions/_gitkeeper"
  end

  test do
    assert_match "0.0.19", shell_output("#{bin}/gitkeeper --version")
  end
end
