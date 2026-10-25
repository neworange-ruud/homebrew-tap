class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.28.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "6960f80b3726ba17a80d7ae09c2cb9d59f313409e348abce716dc9182c2df21d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.28.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "17d9af919f8ae9cd75fbe4ec2694a8de2fb9124b009d3fb610b4a89e8b77072c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.28.0/flightdeck-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff9b358e7a22223a641863b9b29c934117734f3060ca56dda268236bba5dee8f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.28.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "89dd61d6b56e016b17a03445d7f0e01625ff2df95525a192da664e85a561dd89"
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
