#!/bin/bash

echo "🔍 检查GitHub权限和配置..."

# 检查当前分支和标签
echo "📋 当前分支: $(git branch --show-current)"
echo "📋 当前标签: $(git tag --list | tail -5)"

# 检查远程仓库配置
echo "🌐 远程仓库配置:"
git remote -v

# 检查最近的提交
echo "📝 最近的提交:"
git log --oneline -5

# 检查标签是否存在
if git tag --list | grep -q "v1.0.2"; then
    echo "✅ 标签 v1.0.2 存在"
else
    echo "❌ 标签 v1.0.2 不存在"
    echo "💡 创建标签命令: git tag v1.0.2 && git push origin v1.0.2"
fi

# 检查GitHub Actions权限
echo ""
echo "🔧 GitHub Actions 权限检查:"
echo "请确保在 GitHub 仓库设置中:"
echo "1. Settings → Actions → General → Workflow permissions → Read and write permissions"
echo "2. Settings → Actions → General → Allow GitHub Actions to create and approve pull requests"
echo "3. 确保仓库不是私有仓库，或者你有足够的权限"

echo ""
echo "🚀 修复步骤:"
echo "1. 在GitHub仓库页面，进入 Settings → Actions → General"
echo "2. 在 'Workflow permissions' 部分，选择 'Read and write permissions'"
echo "3. 保存设置"
echo "4. 重新推送标签: git push origin v1.0.2"
echo "5. 或者手动触发workflow: 在Actions页面点击 'Run workflow'"
