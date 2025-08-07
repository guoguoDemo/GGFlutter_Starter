# GGFlutter Starter

![logo](assets/gg_icon.svg)

一个现代化、极简高效、可一键配置的 Flutter 脚手架，适合开源项目和企业级应用快速起步。

---

## 🚀 特性亮点
- 一键配置项目名、包名、App 名称、Logo（见 `init_new_flutter_project.sh`）
- Android/iOS 双端 icon 自动生成（SVG/PNG 支持，`flutter_launcher_icons`）
- 支持暗黑/明亮主题切换
- 支持中英文国际化
- go_router 路由统一管理
- Provider 状态管理
- dio 网络请求与异常处理封装
- 丰富通用功能演示（登录、网络、图片、二维码、权限、缓存、Toast、Dialog、Loading、主题色切换等）
- 目录结构清晰，易扩展
- 开箱即用脚本和 CI 配置
- 严格代码规范与自动化测试

## 🛠️ 快速开始

1. **一键初始化项目**
   ```bash
   ./init_new_flutter_project.sh
   # 按提示输入新项目名、包名、App 名称
   ```
2. **自定义 Logo**
   - 将你的 icon（推荐 512x512 PNG）放到 `assets/gg_icon.png`
   - 运行：
     ```bash
     flutter pub run flutter_launcher_icons:main
     ```
   - Android/iOS 双端 icon 自动生成
3. **依赖安装 & 运行**
   ```bash
   flutter pub get
   flutter run
   ```
4. **一键打包 APK**
   ```bash
   ./build_android.sh
   ```
5. **iOS 支持**
   - 目录已自动补全，icon 替换同上
   - 用 Xcode 打开 `ios/Runner.xcworkspace`，可直接打包
   - 如遇 icon 透明通道警告，已自动处理

## 📁 目录结构
- `lib/`：主代码目录，已预设常用结构（utils、widgets、providers、services、models、screens）
- `android/`、`ios/`、`macos/`、`linux/`、`windows/`：多端原生配置
- `assets/`：资源目录，含 logo/icon
- `init_new_flutter_project.sh`：一键初始化脚本
- `.github/`：CI 配置
- `build_android.sh`、`quick_start.sh`：一键打包/开发脚本
- `analysis_options.yaml`：代码规范
- `test/`：自动化测试

## 🧩 功能演示
- 详见 `lib/screens/features_screen.dart`，所有常用功能一键体验
- 主入口见 `lib/main.dart`，多语言、主题、路由、Provider 全集成

## 🧪 自动化测试
- 所有核心功能均有 Widget 测试（见 `test/widget_test.dart`）
- 一键运行：
  ```bash
  flutter test
  ```

## ⚙️ CI/CD
- GitHub Actions 自动化（见 `.github/workflows/`）
- 支持依赖安装、分析、测试、打包、产物上传
- 可自定义发布流程

## 🤝 贡献指南
- 欢迎 PR、Issue，建议遵循 [Flutter 官方代码规范](https://dart.dev/guides/language/analysis-options)
- 代码风格见 `analysis_options.yaml`
- 如有新功能/优化建议，欢迎提交

## 📄 License
MIT

---

如需进一步定制或有疑问，欢迎在 Issues 区留言！
