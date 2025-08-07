#!/bin/bash

echo "=== Flutter 项目脚手架初始化工具 ==="

echo "本工具支持一键设置项目名、包名，并指导如何替换 App Logo。"

echo "建议先全局安装 rename、flutter_launcher_icons 插件："
echo "  flutter pub global activate rename"
echo "  flutter pub add flutter_launcher_icons"
echo

read -rp "请输入新项目目录名（如 my_new_app）: " NEW_PROJECT
if [[ -z "$NEW_PROJECT" ]]; then
  echo "项目名不能为空！"
  exit 1
fi

read -rp "请输入模板原包名（如 com.example.flutter_app_template）: " OLD_PKG
if [[ -z "$OLD_PKG" ]]; then
  echo "原包名不能为空！"
  exit 1
fi

read -rp "请输入新包名（如 com.yourcompany.myapp）: " NEW_PKG
if [[ -z "$NEW_PKG" ]]; then
  echo "新包名不能为空！"
  exit 1
fi

read -rp "请输入新 App 名称（如 我的App）: " NEW_APPNAME
if [[ -z "$NEW_APPNAME" ]]; then
  echo "App 名称不能为空！"
  exit 1
fi

cp -r flutter_app_template "$NEW_PROJECT"
cd "$NEW_PROJECT" || exit 1

export LC_CTYPE=UTF-8
export LANG=UTF-8

echo "正在批量替换包名、项目名、App 名称..."

for ext in dart kt java xml yaml gradle md sh json txt properties; do
  find . -type f -name "*.${ext}" -exec sed -i '' -e "s/$OLD_PKG/$NEW_PKG/g" {} +
  find . -type f -name "*.${ext}" -exec sed -i '' -e "s/flutter_app_template/$NEW_PROJECT/g" {} +
  find . -type f -name "*.${ext}" -exec sed -i '' -e "s/Flutter App Template/$NEW_APPNAME/g" {} +
done

# 重命名Android包目录
OLD_DIR="android/app/src/main/kotlin/$(echo $OLD_PKG | tr '.' '/')"
NEW_DIR="android/app/src/main/kotlin/$(echo $NEW_PKG | tr '.' '/')"
mkdir -p "$(dirname $NEW_DIR)"
if [ -d "$OLD_DIR" ]; then
  mv "$OLD_DIR" "$NEW_DIR"
  for ext in kt java; do
    find android/app/src/main/kotlin -type f -name "*.${ext}" -exec sed -i '' -e "s/$OLD_PKG/$NEW_PKG/g" {} +
  done
fi

echo "✅ 新项目 $NEW_PROJECT 初始化完成，包名已替换为 $NEW_PKG，App 名称已替换为 $NEW_APPNAME"
echo

echo "👉 [可选] 替换 App 图标："
echo "1. 将你的新 icon 文件（如 icon.png）放到项目根目录。"
echo "2. 编辑 pubspec.yaml，配置 flutter_launcher_icons 部分，如："
echo "   flutter_icons:\n     android: true\n     ios: true\n     image_path: 'icon.png'"
echo "3. 运行 flutter pub run flutter_launcher_icons:main 自动生成 icon。"
echo

echo "👉 [可选] 再次修改包名可用： flutter pub global run rename --bundleId $NEW_PKG"
echo

echo "你可以进入 $NEW_PROJECT 目录，运行 flutter pub get 开始开发！"