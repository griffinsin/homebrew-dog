#!/usr/bin/env bash

# 帮助命令
# 用法: man -h 或 man --help

# 导入全局变量
source "$(dirname "$(dirname "$(dirname "${BASH_SOURCE[0]}")")")/lib/globals.sh"

# 显示帮助信息
show_help() {
  echo -e "${BOLD}${TOOL_NAME}${RESET} - 私人 man 工具"
  echo -e "版本: ${GREEN}${VERSION}${RESET}"
  echo
  echo -e "用法: ${BOLD}${TOOL_NAME}${RESET} [选项] [命令名称]"
  echo
  echo -e "选项:"
  echo -e "  ${GREEN}-h, --help${RESET}     显示此帮助信息"
  echo -e "  ${GREEN}-v, --version${RESET}  显示版本信息"
  echo
  echo -e "如果没有提供选项，将调用系统的 man 命令"
}

# 执行帮助命令
help_command() {
  show_help
  return 0
}
