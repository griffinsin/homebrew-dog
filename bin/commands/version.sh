#!/usr/bin/env bash

# 版本命令
# 用法: man -v

# 导入全局变量
source "$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")/lib/globals.sh"

# 显示版本信息
show_version() {
  echo "${TOOL_NAME} 版本 ${VERSION}"
}

# 执行版本命令
version_command() {
  show_version
  return 0
}
