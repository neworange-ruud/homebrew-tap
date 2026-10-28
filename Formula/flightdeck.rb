class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.30.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "9ecd7e0c457b12401be44f98e0f19ac4eb8b8912054b4f2539bdfd9af5c5de84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.30.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "dad38a30495258669119e656aaf6328c4f8a3891b5659cb600f0581e7dcc7d4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.30.0/flightdeck-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b3f5e1c945fde8795ee443d0197e379a5cbef98a305e78401e4d214117c67c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.30.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9fe7b88ee1b8905d14193b1b03158c02543a581ad825499a481afa09e5b93950"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flightdeck"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "flightdeck"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "flightdeck"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "flightdeck"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
