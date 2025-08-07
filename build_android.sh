#!/bin/bash
set -e

# 自动售货机控制应用 - Android构建脚本

echo "开始构建Android应用..."

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "错误: 未找到Flutter，请先安装Flutter SDK"
    exit 1
fi

# 检查Android环境
if ! command -v adb &> /dev/null; then
    echo "警告: 未找到ADB，可能无法自动安装到设备"
fi

echo "==== 获取依赖 ===="
flutter pub get

echo "==== 代码格式化 ===="
flutter format .

echo "==== 静态分析 ===="
flutter analyze

echo "==== 运行测试 ===="
flutter test

echo "==== 构建 APK ===="
flutter build apk --release

# 检查构建结果
if [ $? -eq 0 ]; then
    echo "✅ 构建成功！"
    echo "APK文件位置: build/app/outputs/flutter-apk/app-release.apk"
    
    # 检查是否有连接的Android设备
    if command -v adb &> /dev/null; then
        echo "检查连接的设备..."
        adb devices
        
        # 询问是否安装到设备
        read -p "是否要安装到连接的设备？(y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "安装APK到设备..."
            adb install build/app/outputs/flutter-apk/app-release.apk
            if [ $? -eq 0 ]; then
                echo "✅ 安装成功！"
            else
                echo "❌ 安装失败"
            fi
        fi
    fi
else
    echo "❌ 构建失败"
    exit 1
fi 