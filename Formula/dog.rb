class Dog < Formula
  desc "Personal dog tool"
  homepage "https://github.com/griffinsin/dog"
  version "1.0.9"
  license "MIT"
  
  url "https://github.com/griffinsin/dog/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "464c175922a32e6fc6274d570d1862396edf16d081c4f2ff5f721b81a1161925"
  
  # Note: sha256 value will be updated automatically after GitHub release is created

  def install
    bin.install "bin/dog"
    prefix.install "lib"
    prefix.install "bin/commands"
    
    # Fix path references in dog script
    inreplace bin/"dog", '$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/globals.sh', "#{prefix}/lib/globals.sh"
    
    # Fix command path references
    inreplace bin/"dog", 'COMMANDS_DIR=$(dirname "${BASH_SOURCE[0]}")/commands', "COMMANDS_DIR=#{prefix}/commands"
    
    # Fix command execution - save command name before shift
    inreplace bin/"dog", "# 执行命令\nshift\nsource \"${COMMANDS_DIR}/$1.sh\" \"$@\"", "# Execute command\nCMD=$1\nshift\nsource \"${COMMANDS_DIR}/$CMD.sh\" \"$@\""
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/dog -v")
  end
end
