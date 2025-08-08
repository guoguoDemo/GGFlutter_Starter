#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🧪 本地构建测试${NC}"
echo ""

# 检查Flutter版本
echo -e "${BLUE}📋 检查Flutter版本...${NC}"
flutter --version
echo ""

# 检查Dart版本
echo -e "${BLUE}📋 检查Dart版本...${NC}"
dart --version
echo ""

# 清理旧的构建文件
echo -e "${BLUE}🧹 清理旧的构建文件...${NC}"
flutter clean
echo ""

# 获取依赖
echo -e "${BLUE}📦 获取依赖...${NC}"
if flutter pub get; then
    echo -e "${GREEN}✅ 依赖获取成功${NC}"
else
    echo -e "${RED}❌ 依赖获取失败${NC}"
    exit 1
fi
echo ""

# 生成启动图标
echo -e "${BLUE}🎨 生成启动图标...${NC}"
if flutter pub run flutter_launcher_icons:main; then
    echo -e "${GREEN}✅ 启动图标生成成功${NC}"
else
    echo -e "${RED}❌ 启动图标生成失败${NC}"
    exit 1
fi
echo ""

# 分析代码
echo -e "${BLUE}🔍 分析代码...${NC}"
if flutter analyze; then
    echo -e "${GREEN}✅ 代码分析通过${NC}"
else
    echo -e "${YELLOW}⚠️  代码分析发现问题，但继续构建...${NC}"
fi
echo ""

# 构建APK（仅用于测试，不实际生成文件）
echo -e "${BLUE}🔨 测试构建过程...${NC}"
echo "注意：这只是测试构建过程，不会生成实际的APK文件"
if flutter build apk --debug --no-tree-shake-icons; then
    echo -e "${GREEN}✅ 构建测试成功${NC}"
else
    echo -e "${RED}❌ 构建测试失败${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}🎉 本地构建测试完成！${NC}"
echo -e "${BLUE}📋 如果所有测试都通过，你的环境应该可以正常构建APK${NC}"
