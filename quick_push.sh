#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 快速推送脚本${NC}"
echo ""

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}📝 检测到未提交的更改，请先提交:${NC}"
    git status --short
    echo ""
    echo -e "${YELLOW}💡 使用以下命令提交:${NC}"
    echo "  git add ."
    echo "  git commit -m 'your message'"
    echo "  ./quick_push.sh"
    exit 1
fi

# 获取当前分支
current_branch=$(git branch --show-current)
echo -e "${BLUE}📋 当前分支: $current_branch${NC}"

# 推送代码
echo -e "${BLUE}📤 推送代码到远程仓库...${NC}"
if git push origin $current_branch; then
    echo -e "${GREEN}✅ 代码推送成功!${NC}"
    echo ""
    echo -e "${BLUE}📋 下一步:${NC}"
    echo "1. 查看Actions: https://github.com/guoguoDemo/GGFlutter_Starter/actions"
    echo "2. 如需发布新版本，运行: ./push_release.sh 1.0.3"
else
    echo -e "${RED}❌ 推送失败${NC}"
    exit 1
fi
