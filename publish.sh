#!/usr/bin/env bash

# publish.sh - 自动化Homebrew dog tap发布流程
# 用法: ./publish.sh
# 脚本会自动递增版本号并发布

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# 获取当前目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 从 globals.sh 获取当前版本号
CURRENT_VERSION=$(grep -E 'VERSION="[0-9]+\.[0-9]+\.[0-9]+"' lib/globals.sh | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
echo -e "${BLUE}当前版本: ${CURRENT_VERSION}${RESET}"

# 递增版本号
MAJOR=$(echo $CURRENT_VERSION | cut -d. -f1)
MINOR=$(echo $CURRENT_VERSION | cut -d. -f2)
PATCH=$(echo $CURRENT_VERSION | cut -d. -f3)

# 递增补丁版本号
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"

# 检查标签是否存在，如果存在则再次递增版本号
while git rev-parse "v$NEW_VERSION" >/dev/null 2>&1; do
  echo -e "${YELLOW}标签 v$NEW_VERSION 已存在，递增版本号${RESET}"
  NEW_PATCH=$((NEW_PATCH + 1))
  NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"
done

echo -e "${GREEN}新版本: ${NEW_VERSION}${RESET}"

# 首先更新globals.sh中的版本号
sed -i '' "s/VERSION=\"[0-9]\+\.[0-9]\+\.[0-9]\+\"/VERSION=\"$NEW_VERSION\"/" lib/globals.sh
echo -e "${GREEN}已更新globals.sh中的版本号${RESET}"

# 检查工作目录是否干净
if [ -n "$(git status --porcelain)" ]; then
  echo -e "${YELLOW}工作目录不干净，提交所有更改...${RESET}"
  git add .
  git commit -m "准备发布版本 $NEW_VERSION"
  echo -e "${GREEN}已提交所有更改${RESET}"
fi

# 推送到GitHub
echo -e "${BLUE}推送到GitHub...${RESET}"
git push origin main
echo -e "${GREEN}已推送到GitHub${RESET}"

# 创建标签
echo -e "${BLUE}创建标签 v$NEW_VERSION...${RESET}"
if git rev-parse "v$NEW_VERSION" >/dev/null 2>&1; then
  echo -e "${YELLOW}标签 v$NEW_VERSION 已存在，跳过创建标签步骤${RESET}"
else
  git tag -a "v$NEW_VERSION" -m "版本 $NEW_VERSION"
  git push origin "v$NEW_VERSION"
  echo -e "${GREEN}已创建并推送标签${RESET}"
fi

# 等待GitHub生成源代码包
echo -e "${YELLOW}等待GitHub生成源代码包...${RESET}"
sleep 10  # 增加等待时间，确保GitHub有足够的时间生成源代码包

# 定义源代码包URL
TARBALL_URL="https://github.com/griffinsin/homebrew-dog/archive/refs/tags/v$NEW_VERSION.tar.gz"
echo -e "${BLUE}源代码包URL: $TARBALL_URL${RESET}"

# 直接计算SHA256并更新Formula/dog.rb
echo -e "${BLUE}计算SHA256并更新Formula/dog.rb...${RESET}"
SHA256=$(curl -Ls "$TARBALL_URL" | shasum -a 256 | cut -d ' ' -f 1)
echo -e "${GREEN}SHA256: $SHA256${RESET}"

# 然后更新Formula/dog.rb中的版本号、URL和SHA256
# 使用更精确的方式更新文件内容

# 读取当前文件内容
FORMULA_CONTENT=$(cat Formula/dog.rb)

# 替换版本号
FORMULA_CONTENT=$(echo "$FORMULA_CONTENT" | sed "s/version \"[0-9]\+\.[0-9]\+\.[0-9]\+\"/version \"$NEW_VERSION\"/")

# 替换URL
FORMULA_CONTENT=$(echo "$FORMULA_CONTENT" | sed "s|url \"https://github.com/griffinsin/homebrew-dog/archive/refs/tags/v[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz\"|url \"https://github.com/griffinsin/homebrew-dog/archive/refs/tags/v$NEW_VERSION.tar.gz\"|")

# 替换SHA256
FORMULA_CONTENT=$(echo "$FORMULA_CONTENT" | sed "s/sha256 \"[a-f0-9]\{64\}\"/sha256 \"$SHA256\"/")

# 写回文件
echo "$FORMULA_CONTENT" > Formula/dog.rb

# 打印更新后的文件内容进行验证
echo -e "${BLUE}更新后的Formula/dog.rb文件内容:${RESET}"
grep -E 'version|url|sha256' Formula/dog.rb

echo -e "${GREEN}已更新Formula/dog.rb中的版本号、URL和SHA256${RESET}"

# 提交并推送更改
git add Formula/dog.rb
git commit -m "更新版本 $NEW_VERSION 的信息"
git push origin main
echo -e "${GREEN}已提交并推送Formula/dog.rb更新${RESET}"

echo -e "${GREEN}发布完成！版本 $NEW_VERSION 已成功发布。${RESET}"
echo -e "${BLUE}用户现在可以通过以下命令安装:${RESET}"
echo -e "${YELLOW}brew tap griffinsin/dog${RESET}"
echo -e "${YELLOW}brew install griffinsin/dog/dog${RESET}"