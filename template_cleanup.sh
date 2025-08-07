#!/bin/bash

cd "$(dirname "$0")/ggflutter_starter" || exit 1

echo "正在清理业务相关文件..."

# 删除业务相关 Dart 文件
rm -f lib/models/*.dart
rm -f lib/services/*.dart
rm -f lib/providers/*.dart
rm -f lib/widgets/*.dart
rm -f lib/screens/home_screen.dart

# 为每个空目录添加 README.md
for dir in lib/models lib/services lib/providers lib/widgets; do
  echo "本目录用于存放通用组件（或状态管理/服务/数据模型），可根据实际项目需求添加。" > "$dir/README.md"
done

# 添加模板首页
cat > lib/screens/home_screen.dart <<EOF
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter App Template')),
      body: const Center(child: Text('Hello, Flutter Template!')),
    );
  }
}
EOF

# 替换 main.dart
cat > lib/main.dart <<EOF
import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App Template',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
EOF

# 自动更新 pubspec.yaml
cat > pubspec.yaml <<EOF
name: ggflutter_starter
description: 通用Flutter项目模板，适合快速开发新应用
version: 1.0.0+1

environment:
  sdk: ">=2.19.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  flutter_bloc: ^9.1.1
  provider: ^6.0.5
  dio: ^5.3.2
  shared_preferences: ^2.2.0
  permission_handler: ^12.0.1
  device_info_plus: ^11.5.0
  logger: ^2.0.2+1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
EOF

# 自动更新 README.md
cat > README.md <<EOF
# Flutter App Template

本模板适用于快速创建高质量Flutter应用，内置最佳实践的目录结构、构建优化、主题配置和常用依赖。

## 快速开始

1. **复制本模板目录**，重命名为你的新项目名。
2. **全局替换包名**（如 com.example.app），可用IDE或文本编辑器批量替换。
3. **修改 pubspec.yaml**，填写你的项目名、描述、依赖等。
4. **运行依赖安装**  
   \`\`\`bash
   flutter pub get
   \`\`\`
5. **运行项目**  
   \`\`\`bash
   flutter run
   \`\`\`
6. **打包APK**  
   \`\`\`bash
   ./build_android.sh
   # 或
   ./quick_start.sh
   \`\`\`

## 目录结构说明

- \`lib/\`：主代码目录，已预设常用结构（utils、widgets、providers、services、models、screens）
- \`android/\`：Android原生配置，已优化构建和混淆
- \`build_android.sh\`、\`quick_start.sh\`：一键构建脚本
- \`analysis_options.yaml\`：代码规范

## 推荐用法

- 直接在 \`lib/screens/\` 新建页面
- 通用组件放在 \`lib/widgets/\`
- 状态管理类放在 \`lib/providers/\`
- 服务类（如网络、权限等）放在 \`lib/services/\`
- 数据模型放在 \`lib/models/\`
- 主题相关放在 \`lib/utils/theme.dart\`

## 其他

- 如需添加业务模块，建议以插件或独立目录方式组织，便于后续复用。
- 如需自定义主题，直接修改 \`lib/utils/theme.dart\`。

---

如需进一步定制或有疑问，欢迎随时提问！
EOF

echo "模板清理和 pubspec.yaml、README.md 自动更新完成！"