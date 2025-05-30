class Dog < Formula
  desc "私人 dog 工具"
  homepage "https://github.com/griffinsin/homebrew-dog"
  version "1.0.2"
  license "MIT"
  
  url "https://github.com/griffinsin/homebrew-dog/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d5c2130f27317d827a23b1ecd42931d466df28c906f76985c3bcf628c7f598b3"
  
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
