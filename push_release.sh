#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    echo -e "${BLUE}🚀 GGFlutter Starter 发布脚本${NC}"
    echo ""
    echo "用法:"
    echo "  $0 [选项] [版本号]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -v, --version  显示当前版本"
    echo "  -c, --check    检查当前状态"
    echo "  -f, --force    强制推送（跳过确认）"
    echo ""
    echo "示例:"
    echo "  $0 1.0.3       发布版本 1.0.3"
    echo "  $0 -c          检查当前状态"
    echo "  $0 -f 1.0.4    强制发布版本 1.0.4"
    echo ""
}

# 检查当前状态
check_status() {
    echo -e "${BLUE}🔍 检查当前状态...${NC}"
    echo ""
    
    # 检查当前分支
    current_branch=$(git branch --show-current)
    echo -e "${YELLOW}📋 当前分支: ${current_branch}${NC}"
    
    # 检查是否有未提交的更改
    if [[ -n $(git status --porcelain) ]]; then
        echo -e "${RED}❌ 有未提交的更改:${NC}"
        git status --short
        echo ""
        echo -e "${YELLOW}💡 请先提交更改:${NC}"
        echo "  git add ."
        echo "  git commit -m 'your commit message'"
        return 1
    else
        echo -e "${GREEN}✅ 工作目录干净${NC}"
    fi
    
    # 检查远程仓库
    echo -e "${YELLOW}🌐 远程仓库:${NC}"
    git remote -v
    
    # 显示最近的标签
    echo -e "${YELLOW}📝 最近的标签:${NC}"
    git tag --sort=-version:refname | head -5
    
    # 显示最近的提交
    echo -e "${YELLOW}📝 最近的提交:${NC}"
    git log --oneline -3
    
    return 0
}

# 验证版本号格式
validate_version() {
    local version=$1
    if [[ ! $version =~ ^v?[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "${RED}❌ 无效的版本号格式: $version${NC}"
        echo "正确的格式: v1.0.0 或 1.0.0"
        return 1
    fi
    
    # 确保版本号以 v 开头
    if [[ ! $version =~ ^v ]]; then
        version="v$version"
    fi
    
    echo $version
}

# 检查版本是否已存在
check_version_exists() {
    local version=$1
    if git tag --list | grep -q "^$version$"; then
        echo -e "${RED}❌ 版本 $version 已存在${NC}"
        return 1
    fi
    return 0
}

# 推送代码和创建标签
push_release() {
    local version=$1
    local force=$2
    
    echo -e "${BLUE}🚀 开始发布版本 $version${NC}"
    echo ""
    
    # 检查状态
    if ! check_status; then
        return 1
    fi
    
    # 验证版本号
    version=$(validate_version $version)
    if [[ $? -ne 0 ]]; then
        return 1
    fi
    
    # 检查版本是否已存在
    if ! check_version_exists $version; then
        return 1
    fi
    
    # 确认操作
    if [[ "$force" != "true" ]]; then
        echo -e "${YELLOW}⚠️  确认要发布版本 $version 吗? (y/N)${NC}"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}❌ 操作已取消${NC}"
            return 1
        fi
    fi
    
    echo ""
    echo -e "${BLUE}📤 推送代码到远程仓库...${NC}"
    
    # 推送代码
    if ! git push origin main; then
        echo -e "${RED}❌ 推送代码失败${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ 代码推送成功${NC}"
    
    # 创建标签
    echo -e "${BLUE}🏷️  创建标签 $version...${NC}"
    if ! git tag $version; then
        echo -e "${RED}❌ 创建标签失败${NC}"
        return 1
    fi
    
    # 推送标签
    echo -e "${BLUE}📤 推送标签到远程仓库...${NC}"
    if ! git push origin $version; then
        echo -e "${RED}❌ 推送标签失败${NC}"
        return 1
    fi
    
    echo ""
    echo -e "${GREEN}🎉 发布成功!${NC}"
    echo -e "${GREEN}✅ 版本 $version 已发布${NC}"
    echo ""
    echo -e "${BLUE}📋 下一步:${NC}"
    echo "1. 查看构建状态: https://github.com/guoguoDemo/GGFlutter_Starter/actions"
    echo "2. 下载APK: https://github.com/guoguoDemo/GGFlutter_Starter/releases"
    echo "3. 检查release: https://github.com/guoguoDemo/GGFlutter_Starter/releases/tag/$version"
    echo ""
}

# 显示当前版本
show_version() {
    echo -e "${BLUE}📋 当前版本信息:${NC}"
    echo "脚本版本: 1.0.0"
    echo "最新标签: $(git tag --sort=-version:refname | head -1)"
    echo "当前分支: $(git branch --show-current)"
    echo "远程仓库: $(git remote get-url origin)"
}

# 主函数
main() {
    local version=""
    local force=false
    local check_only=false
    local show_version_only=false
    
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version_only=true
                shift
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -*)
                echo -e "${RED}❌ 未知选项: $1${NC}"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$version" ]]; then
                    version=$1
                else
                    echo -e "${RED}❌ 只能指定一个版本号${NC}"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # 显示版本信息
    if [[ "$show_version_only" == "true" ]]; then
        show_version
        exit 0
    fi
    
    # 检查状态
    if [[ "$check_only" == "true" ]]; then
        check_status
        exit $?
    fi
    
    # 如果没有提供版本号，显示帮助
    if [[ -z "$version" ]]; then
        echo -e "${RED}❌ 请提供版本号${NC}"
        echo ""
        show_help
        exit 1
    fi
    
    # 推送发布
    push_release "$version" "$force"
    exit $?
}

# 运行主函数
main "$@"
