# 🚀 GGFlutter Starter 推送指南

## 📋 快速开始

### 日常开发推送
```bash
# 提交代码
git add .
git commit -m "feat: 添加新功能"

# 快速推送
./quick_push.sh
```

### 发布新版本
```bash
# 发布版本 1.0.3
./push_release.sh 1.0.3

# 强制发布（跳过确认）
./push_release.sh -f 1.0.4
```

## 📝 脚本说明

### 1. `quick_push.sh` - 快速推送脚本
用于日常开发时的代码推送，不创建标签。

**功能：**
- ✅ 检查未提交的更改
- ✅ 推送代码到远程仓库
- ✅ 显示下一步操作提示

**使用：**
```bash
./quick_push.sh
```

### 2. `push_release.sh` - 发布脚本
用于发布新版本，会自动创建标签并触发GitHub Actions构建。

**功能：**
- ✅ 验证版本号格式
- ✅ 检查版本是否已存在
- ✅ 推送代码和标签
- ✅ 触发GitHub Actions构建
- ✅ 显示发布后的链接

**选项：**
- `-h, --help` - 显示帮助信息
- `-v, --version` - 显示版本信息
- `-c, --check` - 检查当前状态
- `-f, --force` - 强制发布（跳过确认）

**使用示例：**
```bash
# 发布版本 1.0.3
./push_release.sh 1.0.3

# 检查当前状态
./push_release.sh -c

# 强制发布版本 1.0.4
./push_release.sh -f 1.0.4

# 显示帮助
./push_release.sh -h
```

## 🔧 工作流程

### 日常开发流程
1. **修改代码**
2. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加新功能"
   ```
3. **推送代码**
   ```bash
   ./quick_push.sh
   ```
4. **查看构建状态**
   - 访问：https://github.com/guoguoDemo/GGFlutter_Starter/actions

### 发布新版本流程
1. **完成功能开发**
2. **提交所有更改**
   ```bash
   git add .
   git commit -m "feat: 完成新功能"
   ```
3. **发布新版本**
   ```bash
   ./push_release.sh 1.0.3
   ```
4. **等待构建完成**
   - 查看Actions：https://github.com/guoguoDemo/GGFlutter_Starter/actions
   - 下载APK：https://github.com/guoguoDemo/GGFlutter_Starter/releases

## 📊 版本号规范

使用语义化版本号：`主版本.次版本.修订版本`

**示例：**
- `1.0.0` - 第一个正式版本
- `1.0.1` - 修复bug
- `1.1.0` - 添加新功能
- `2.0.0` - 重大更新

## 🔗 重要链接

- **GitHub仓库**: https://github.com/guoguoDemo/GGFlutter_Starter
- **Actions构建**: https://github.com/guoguoDemo/GGFlutter_Starter/actions
- **Releases**: https://github.com/guoguoDemo/GGFlutter_Starter/releases
- **Settings**: https://github.com/guoguoDemo/GGFlutter_Starter/settings

## ⚠️ 注意事项

1. **确保权限设置正确**
   - GitHub仓库 → Settings → Actions → General
   - 确保 "Workflow permissions" 设置为 "Read and write permissions"

2. **版本号不能重复**
   - 脚本会自动检查版本是否已存在
   - 如果版本已存在，需要删除旧标签或使用新版本号

3. **工作目录必须干净**
   - 发布前确保没有未提交的更改
   - 使用 `git status` 检查状态

4. **网络连接**
   - 确保网络连接稳定
   - 推送失败时检查网络和GitHub状态

## 🆘 故障排除

### 推送失败
```bash
# 检查网络连接
ping github.com

# 检查Git配置
git config --list

# 重新认证
git push origin main
```

### 版本已存在
```bash
# 删除本地标签
git tag -d v1.0.3

# 删除远程标签
git push origin :refs/tags/v1.0.3

# 重新发布
./push_release.sh 1.0.3
```

### Actions构建失败
1. 检查GitHub Actions权限设置
2. 查看构建日志中的具体错误
3. 确保Flutter版本兼容性
4. 检查依赖项是否正确

## 📞 获取帮助

如果遇到问题，可以：

1. **查看脚本帮助**
   ```bash
   ./push_release.sh -h
   ```

2. **检查当前状态**
   ```bash
   ./push_release.sh -c
   ```

3. **查看GitHub Actions日志**
   - 访问Actions页面查看详细错误信息

4. **联系维护者**
   - 在GitHub Issues中报告问题
