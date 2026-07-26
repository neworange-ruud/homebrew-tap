class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.12.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "fee05ce30dc86ac51b2e1320ff158ee001f2fb78a08765397ad7a0addb3b597c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.12.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "c2cb2f376576eded16deaf35d6b169035d4a252c376be784a8e3ff2728080053"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.12.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "9cb9a1815110448a22450f5eebd9d93e8b964d9ebfd80d3d5d72a3c31f3ce1ec"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "flightdeck" if OS.mac? && Hardware::CPU.arm?
    bin.install "flightdeck" if OS.mac? && Hardware::CPU.intel?
    bin.install "flightdeck" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
