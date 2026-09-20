class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.21.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.21.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "fdca1d70dd58dfe20504b1a74f25e366fa766ae929ae8663f8e7835ffc12b153"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.21.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "d102c2749be096dfc1c6940abf64803b6aa6645b55284f1755817591140a2874"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.21.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c78138a0eececf6727ef100b6c5c144072c8c22554b23cb7681a52b32679f32a"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "flightdeck"
    end
    if OS.mac? && Hardware::CPU.intel?
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
