class Bagel < Formula
  desc "CLI to audit posture and evaluate compromise blast radius"
  homepage "https://boostsecurityio.github.io/bagel/"
  version "0.2.0"
  license "GPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/boostsecurityio/bagel/releases/download/v#{version}/bagel_Darwin_arm64.tar.gz"
      sha256 "ee9908ff268ec00ec9524f817abc5855e29e06aa52bb7e4cce9e129c921a0f1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boostsecurityio/bagel/releases/download/v#{version}/bagel_Darwin_x86_64.tar.gz"
      sha256 "053dd417552d76d88e337973231887628194684b6d1cae762967eaef202d2e6a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/boostsecurityio/bagel/releases/download/v#{version}/bagel_Linux_arm64.tar.gz"
      sha256 "c02056252b2434ae9ede2edd86fafa684ff9f9a7c3c47bf41d2e7de465824ff0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/boostsecurityio/bagel/releases/download/v#{version}/bagel_Linux_x86_64.tar.gz"
      sha256 "81eefb03a6a89a07c34c9c7cfc1861a8477a80c14451b8a13b582f7132660654"
    end
  end

  def install
    bin.install "bagel"
    generate_completions_from_executable(bin/"bagel", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bagel version")

    (testpath/"bagel.yaml").write <<~YAML
      version: 1
      file_index:
        base_dirs: ["#{testpath}"]
    YAML

    (testpath/".aws").mkpath
    (testpath/".aws/credentials").write <<~INI
      [default]
      aws_access_key_id = AKIAIOSFODNN7EXAMPLE
      aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
    INI

    output = shell_output("#{bin}/bagel scan --config #{testpath}/bagel.yaml")
    assert_match "AWS", output
  end
end
