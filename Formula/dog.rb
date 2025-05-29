class Dog < Formula
  desc "私人 dog 工具"
  homepage "https://github.com/griffinsin/homebrew-dog"
  version "1.0.1"
  license "MIT"
  
  url "https://github.com/griffinsin/homebrew-dog/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6bef968bc785a9398c78dcf61bdb0f588252113c017268adfafb450fd90a8edf"
  
  # 注意：sha256值需要在创建GitHub release后更新为实际值

  def install
    bin.install "bin/dog"
    prefix.install "lib"
    prefix.install "bin/commands"
    
    # 修改dog脚本中的路径引用
    inreplace bin/"dog", "$(dirname \"$(dirname \"${BASH_SOURCE[0]}\")\")/lib/globals.sh", "#{prefix}/lib/globals.sh"
    inreplace bin/"dog", "${COMMANDS_DIR}/$1.sh", "#{prefix}/commands/$1.sh"
  end

  test do
    assert_match "版本 #{version}", shell_output("#{bin}/dog -v")
  end
end
