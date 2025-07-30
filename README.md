# 自动售货机控制应用

这是一个基于Flutter开发的Android应用，用于通过串口通信控制自动售货机设备。

## 功能特性

- 🔍 **设备扫描**: 自动扫描可用的串口设备
- 🔗 **串口连接**: 支持多种串口参数配置
- 🎮 **电机控制**: 支持单个和批量电机控制
- 📊 **实时监控**: 实时显示串口通信数据
- 📱 **移动端**: 专为Android平板优化

## 系统要求

- Android 5.0 (API 21) 或更高版本
- 支持USB OTG的Android设备
- 串口转USB适配器

## 安装说明

### 1. 环境准备

确保已安装以下工具：
- Flutter SDK (3.0.0+)
- Android Studio
- Android SDK
- ADB工具

### 2. 构建应用

```bash
# 进入项目目录
cd flutter_app

# 获取依赖
flutter pub get

# 构建APK
flutter build apk --release
```

### 3. 安装到设备

```bash
# 连接Android设备
adb devices

# 安装APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

或者使用构建脚本：
```bash
chmod +x build_android.sh
./build_android.sh
```

## 使用说明

### 1. 设备连接

1. 打开应用
2. 点击"设备"标签页
3. 点击刷新按钮扫描设备
4. 选择要连接的串口设备
5. 配置串口参数（波特率、数据位等）
6. 点击"连接"

### 2. 电机控制

1. 点击"控制"标签页
2. 选择要控制的电机编号
3. 点击"启动电机"或"停止电机"
4. 或使用"批量控制"功能

### 3. 数据监控

1. 点击"监控"标签页
2. 查看实时接收的数据
3. 数据会自动解析显示功能码和寄存器地址

## 串口协议

应用支持Modbus RTU协议：

### 电机控制指令
- **启动电机**: `00 05 [寄存器地址] FF 00 [CRC]`
- **停止电机**: `00 05 [寄存器地址] 00 00 [CRC]`

### 寄存器地址
- 电机1: 0x031A
- 电机2: 0x031B
- 电机3: 0x031C
- ...以此类推

### 功能码
- 0x01: 读线圈状态
- 0x03: 读保持寄存器
- 0x05: 写单个线圈
- 0x06: 写单个寄存器

## 权限说明

应用需要以下权限：
- `WRITE_EXTERNAL_STORAGE`: 串口设备访问
- `READ_EXTERNAL_STORAGE`: 串口设备访问
- `USB_PERMISSION`: USB设备权限

## 故障排除

### 1. 设备未检测到
- 检查USB连接
- 确认设备驱动已安装
- 尝试重新插拔设备

### 2. 连接失败
- 检查串口参数设置
- 确认设备未被其他程序占用
- 检查设备权限

### 3. 指令无响应
- 检查设备地址是否正确
- 确认指令格式符合协议要求
- 查看监控页面的错误信息

## 开发说明

### 项目结构
```
lib/
├── main.dart                 # 应用入口
├── providers/               # 状态管理
│   └── serial_provider.dart
├── models/                  # 数据模型
│   ├── serial_device.dart
│   └── serial_command.dart
├── services/               # 服务层
│   └── serial_service.dart
├── screens/                # 页面
│   └── home_screen.dart
├── widgets/                # 组件
│   ├── device_list_widget.dart
│   ├── connection_widget.dart
│   ├── motor_control_widget.dart
│   └── data_monitor_widget.dart
└── utils/                  # 工具类
    └── theme.dart
```

### 自定义开发

如需添加新功能，可以：

1. **添加新的指令类型**:
   - 在 `SerialCommand` 类中添加新的工厂方法
   - 在 `MotorControlWidget` 中添加对应的UI

2. **扩展设备支持**:
   - 在 `SerialCommunicationPlugin.kt` 中添加新的设备检测逻辑
   - 更新 `isSerialDevice` 方法

3. **修改UI界面**:
   - 编辑对应的Widget文件
   - 更新主题配置

## 许可证

本项目仅供内部使用，请勿外传。

## 联系方式

如有问题，请联系开发团队。 