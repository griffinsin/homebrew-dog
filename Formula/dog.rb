class Dog < Formula
  desc "私人 dog 工具"
  homepage "https://github.com/griffinsin/dog"
  version "1.0.8"
  license "MIT"
  
  url "https://github.com/griffinsin/dog/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "1c8afc5545fd01e00b6ab3843678dcc7143b368965ab4efe332c4504c4a1a8d2"
  
  # 注意：sha256值需要在创建GitHub release后更新为实际值

  def install
    bin.install "bin/dog"
    prefix.install "lib"
    prefix.install "bin/commands"
    
    # 修改dog脚本中的路径引用
    inreplace bin/"dog", "$(dirname \"$(dirname \"${BASH_SOURCE[0]}\")\")/lib/globals.sh", "#{prefix}/lib/globals.sh"
    
    # 修改命令路径引用 - 修复检查和执行命令的部分
    inreplace bin/"dog", "if [[ ! -f \"${COMMANDS_DIR}/$1.sh\" ]]; then", "if [[ ! -f \"#{prefix}/commands/$1.sh\" ]]; then"
    
    # 修复命令执行部分，保存命令名称后再shift
    inreplace bin/"dog", "# 执行命令\nshift\nsource \"${COMMANDS_DIR}/$1.sh\" \"$@\"", "# 执行命令\nCMD=$1\nshift\nsource \"#{prefix}/commands/$CMD.sh\" \"$@\""
  end

  test do
    assert_match "版本 #{version}", shell_output("#{bin}/dog -v")
  end
end
