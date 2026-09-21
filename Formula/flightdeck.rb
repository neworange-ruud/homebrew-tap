class Flightdeck < Formula
  desc "A cross-platform terminal UI for orchestrating multiple local AI coding agents in isolated Git worktrees."
  homepage "https://github.com/neworange-ruud/flightdeck"
  version "1.22.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.22.0/flightdeck-aarch64-apple-darwin.tar.xz"
      sha256 "99a8d8af2ea6f76d079e02a4c36d84bc93549482f4365376aee3d80439858a37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.22.0/flightdeck-x86_64-apple-darwin.tar.xz"
      sha256 "5d35e5c93003ef7f6025668a868b4968d0f69bc848d25f067dbb6a1a9f133bd4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/neworange-ruud/flightdeck/releases/download/v1.22.0/flightdeck-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8ac95b51e365565ce574d4d8010aaa276b45d5103aa4a28f57b05a2e926fb748"
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
