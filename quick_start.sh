#!/bin/bash
set -e

# 快速启动脚本 - 自动售货机控制应用

echo "🚀 自动售货机控制应用 - 快速启动"
echo "=================================="

# 检查Flutter环境
echo "📋 检查Flutter环境..."
if ! command -v flutter &> /dev/null; then
    echo "❌ 错误: 未找到Flutter SDK"
    echo "请先安装Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter版本: $(flutter --version | head -n 1)"

# 检查Android环境
echo "📱 检查Android环境..."
if ! command -v adb &> /dev/null; then
    echo "⚠️  警告: 未找到ADB工具"
    echo "请安装Android SDK Platform Tools"
else
    echo "✅ ADB工具已安装"
fi

# 进入项目目录
cd "$(dirname "$0")"

echo "==== 获取依赖 ===="
flutter pub get

echo "==== 代码格式化 ===="
flutter format .

echo "==== 静态分析 ===="
flutter analyze

echo "==== 运行测试 ===="
flutter test

echo "==== 启动项目 ===="
flutter run 