class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.38.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "b951d6bac3b6ee942b576edaf7f0dc155b213b1ed4d0c26b06d019f3a1114abd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.38.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "5ec9bc8a43a1f40afc4c8bb1a54e49c4fa9c4065b77fe8a9964f9494cfc045c6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.38.0/flightdeck-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29008803bf6a28a43a1ad47fccbbc25014772c2b2903bcf39bf81a7c31702a13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.38.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cdda17803dfff0aa8edd18d76a8e3242b4d668f325b27dd4597b375233a8b262"
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
