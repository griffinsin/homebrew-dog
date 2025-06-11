class Dog < Formula
  desc "私人 dog 工具"
  homepage "https://github.com/griffinsin/dog"
  version "1.0.7"
  license "MIT"
  
  url "https://github.com/griffinsin/dog/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "e796915014c95da50d6afde0db2dff0d84c2aa2b8774974f75308703993961d2"
  
  # 注意：sha256值需要在创建GitHub release后更新为实际值

  def install
    bin.install "bin/dog"
    prefix.install "lib"
    prefix.install "bin/commands"
    
    # 修改dog脚本中的路径引用
    inreplace bin/"dog", "$(dirname \"$(dirname \"${BASH_SOURCE[0]}\")\")/lib/globals.sh", "#{prefix}/lib/globals.sh"
    
    # 修改命令路径引用 - 修复检查和执行命令的部分
    inreplace bin/"dog", "if [[ ! -f \"${COMMANDS_DIR}/$1.sh\" ]]; then", "if [[ ! -f \"#{prefix}/commands/$1.sh\" ]]; then"
    inreplace bin/"dog", "source \"${COMMANDS_DIR}/$1.sh\" \"$@\"", "source \"#{prefix}/commands/$1.sh\" \"$@\""
  end

  test do
    assert_match "版本 #{version}", shell_output("#{bin}/dog -v")
  end
end
