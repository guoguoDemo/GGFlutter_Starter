#!/bin/bash

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

# 获取依赖
echo "📦 获取项目依赖..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ 获取依赖失败"
    exit 1
fi

echo "✅ 依赖获取完成"

# 检查连接的设备
echo "🔍 检查连接的设备..."
if command -v adb &> /dev/null; then
    adb devices
else
    echo "⚠️  无法检查设备，请手动确认设备连接"
fi

# 选择操作
echo ""
echo "请选择操作:"
echo "1) 运行调试版本 (flutter run)"
echo "2) 构建发布版本 (flutter build apk)"
echo "3) 构建并安装到设备"
echo "4) 清理项目"
echo "5) 退出"

read -p "请输入选项 (1-5): " choice

case $choice in
    1)
        echo "🔧 启动调试模式..."
        flutter run
        ;;
    2)
        echo "🏗️  构建发布版本..."
        flutter build apk --release
        if [ $? -eq 0 ]; then
            echo "✅ 构建成功！APK位置: build/app/outputs/flutter-apk/app-release.apk"
        else
            echo "❌ 构建失败"
        fi
        ;;
    3)
        echo "🚀 构建并安装..."
        flutter build apk --release
        if [ $? -eq 0 ]; then
            echo "📱 安装到设备..."
            adb install build/app/outputs/flutter-apk/app-release.apk
            if [ $? -eq 0 ]; then
                echo "✅ 安装成功！"
            else
                echo "❌ 安装失败"
            fi
        else
            echo "❌ 构建失败，无法安装"
        fi
        ;;
    4)
        echo "🧹 清理项目..."
        flutter clean
        echo "✅ 清理完成"
        ;;
    5)
        echo "👋 再见！"
        exit 0
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac 