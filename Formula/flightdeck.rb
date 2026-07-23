class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.11.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "375e44be853e3d239d4b82dcddcc92aa18c9c874ec2820c3dc1e2568ed8c46f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.11.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "9da56af9efaf87cbcb2cf95befae71cdec646761f3520b208a7af8e430882522"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.11.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a447afe53a8345bf9797e9fc70d311c80fb790ddfda9e076ce9dafd23e6a6fe7"
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
