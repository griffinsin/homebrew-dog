#!/usr/bin/env bash

# 全局变量定义文件
# 这个文件包含所有 man 工具使用的全局变量

# 版本信息
VERSION="1.0.0"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m'

# 工具名称
TOOL_NAME="dog"

# 系统 man 路径
SYSTEM_MAN="/usr/bin/man"

# 命令目录路径
# 使用相对路径，这样无论安装在哪里都能正确找到命令文件
COMMANDS_DIR="$(dirname "$(dirname "${BASH_SOURCE[0]}")")/bin/commands"
