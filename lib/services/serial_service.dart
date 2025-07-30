import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vending_machine_control/models/serial_device.dart';
import 'package:vending_machine_control/models/serial_command.dart';
import 'package:logger/logger.dart';

class SerialService {
  final Logger _logger = Logger();
  
  StreamSubscription? _dataSubscription;
  Function(String)? _dataCallback;
  bool _isConnected = false;
  Timer? _mockDataTimer;
  
  // 获取可用串口设备（模拟数据）
  Future<List<SerialDevice>> getAvailableDevices() async {
    // 模拟延迟
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      SerialDevice(
        name: 'USB Serial Device',
        path: '/dev/ttyUSB0',
        description: 'FTDI USB Serial Adapter',
        isAvailable: true,
      ),
      SerialDevice(
        name: 'COM3',
        path: '/dev/tty.usbserial-2120',
        description: 'Silicon Labs CP210x USB to UART Bridge',
        isAvailable: true,
      ),
      SerialDevice(
        name: 'Serial Port 1',
        path: '/dev/ttyS0',
        description: 'Built-in Serial Port',
        isAvailable: false,
      ),
    ];
  }
  
  // 连接串口设备（模拟）
  Future<bool> connect(SerialDevice device, SerialConfig config) async {
    try {
      // 模拟连接延迟
      await Future.delayed(const Duration(seconds: 1));
      
      if (device.isAvailable) {
        _isConnected = true;
        _logger.i('模拟串口连接成功: ${device.name}');
        
        // 开始模拟数据接收
        _startMockData();
        
        return true;
      } else {
        _logger.e('设备不可用: ${device.name}');
        return false;
      }
    } catch (e) {
      _logger.e('模拟串口连接失败: $e');
      return false;
    }
  }
  
  // 断开连接
  Future<void> disconnect() async {
    try {
      _isConnected = false;
      _mockDataTimer?.cancel();
      _mockDataTimer = null;
      _dataSubscription?.cancel();
      _dataSubscription = null;
      _logger.i('模拟串口连接已断开');
    } catch (e) {
      _logger.e('断开模拟串口连接失败: $e');
    }
  }
  
  // 发送指令（模拟）
  Future<bool> sendCommand(SerialCommand command) async {
    if (!_isConnected) {
      _logger.w('模拟串口未连接');
      return false;
    }
    
    try {
      // 模拟发送延迟
      await Future.delayed(const Duration(milliseconds: 200));
      
      _logger.i('模拟发送指令成功: ${command.command}');
      
      // 模拟设备响应
      _simulateResponse(command);
      
      return true;
    } catch (e) {
      _logger.e('模拟发送指令异常: $e');
      return false;
    }
  }
  
  // 开始监听数据
  void startListening(Function(String) callback) {
    _dataCallback = callback;
    _logger.i('开始模拟数据监听');
  }
  
  // 停止监听
  void stopListening() {
    _dataSubscription?.cancel();
    _dataSubscription = null;
    _dataCallback = null;
    _mockDataTimer?.cancel();
    _mockDataTimer = null;
  }
  
  // 检查连接状态
  bool get isConnected => _isConnected;
  
  // 获取串口配置选项
  static List<int> get baudRates => [2400, 4800, 9600, 19200, 38400, 57600, 115200];
  static List<int> get dataBits => [5, 6, 7, 8];
  static List<int> get stopBits => [1, 2];
  static List<String> get parityOptions => ['无', '奇校验', '偶校验'];
  static List<String> get flowControlOptions => ['无', '硬件流控', '软件流控'];
  
  // 获取校验位值
  static int getParityValue(String parity) {
    switch (parity) {
      case '无':
        return 0;
      case '奇校验':
        return 1;
      case '偶校验':
        return 2;
      default:
        return 0;
    }
  }
  
  // 获取流控值
  static int getFlowControlValue(String flowControl) {
    switch (flowControl) {
      case '无':
        return 0;
      case '硬件流控':
        return 1;
      case '软件流控':
        return 2;
      default:
        return 0;
    }
  }
  
  // 开始模拟数据
  void _startMockData() {
    _mockDataTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_isConnected && _dataCallback != null) {
        final responses = [
          '00 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 62 B5',
          '00 03 02 0A 02 00 00 00 00 00 68 00 00 00 00 00 00 00 8E 3E',
          '00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 74',
        ];
        
        final randomResponse = responses[DateTime.now().millisecond % responses.length];
        _dataCallback?.call(randomResponse);
      }
    });
  }
  
  // 模拟设备响应
  void _simulateResponse(SerialCommand command) {
    if (_dataCallback != null) {
      String response;
      
      switch (command.functionCode) {
        case 0x05: // 写单个线圈
          response = '00 05 ${command.registerAddress.toRadixString(16).padLeft(4, '0').toUpperCase()} ${command.data.toRadixString(16).padLeft(4, '0').toUpperCase()} 62 B5';
          break;
        case 0x01: // 读线圈状态
          response = '00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 74';
          break;
        case 0x03: // 读保持寄存器
          response = '00 03 02 0A 02 00 00 00 00 00 68 00 00 00 00 00 00 00 8E 3E';
          break;
        default:
          response = '00 ${command.functionCode.toRadixString(16).padLeft(2, '0').toUpperCase()} 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 62 B5';
      }
      
      // 延迟发送响应
      Timer(const Duration(milliseconds: 500), () {
        _dataCallback?.call(response);
      });
    }
  }
} 