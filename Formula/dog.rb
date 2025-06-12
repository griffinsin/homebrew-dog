class Dog < Formula
  desc "Personal dog tool"
  homepage "https://github.com/griffinsin/dog"
  version "1.0.19"
  license "MIT"
  
  url "https://github.com/griffinsin/dog/archive/refs/tags/v1.0.19.tar.gz"
  sha256 "c230ff6b7e4610c435034842b2cc8179d1fba68c7da24f14323a24beb67f5a94"
  
  # Note: sha256 value will be updated automatically after GitHub release is created

  def install
    bin.install "bin/dog"
    prefix.install "lib"
    prefix.install "bin/commands"
    
    # Fix path references in dog script
    inreplace bin/"dog", '$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/globals.sh', "#{prefix}/lib/globals.sh"
    
    # Fix command path references
    inreplace bin/"dog", 'COMMANDS_DIR=$(dirname "${BASH_SOURCE[0]}")/commands', "COMMANDS_DIR=#{prefix}/commands"
    
    # Create a new dog script with fixed command execution
    dog_content = File.read(bin/"dog")
    new_content = dog_content.gsub(/shift\s*\nsource.*\$1\.sh.*\$@/, "CMD=$1\nshift\nsource \"${COMMANDS_DIR}/$CMD.sh\" \"$@\"")
    File.write(bin/"dog", new_content)
    
    # Fix globals.sh path in all command scripts
    Dir["#{prefix}/commands/*.sh"].each do |script|
      # 读取脚本内容并替换路径
      content = File.read(script)
      content.gsub!(/source.*globals\.sh/, "source #{prefix}/lib/globals.sh")
      File.write(script, content)
    end
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/dog -v")
  end
end
