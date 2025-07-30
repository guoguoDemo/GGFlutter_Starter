import 'package:flutter/foundation.dart';
import 'package:vending_machine_control/models/serial_device.dart';
import 'package:vending_machine_control/models/serial_command.dart';
import 'package:vending_machine_control/services/serial_service.dart';
import 'package:logger/logger.dart';

class SerialProvider with ChangeNotifier {
  final SerialService _serialService = SerialService();
  final Logger _logger = Logger();
  
  // 状态变量
  List<SerialDevice> _availableDevices = [];
  SerialDevice? _connectedDevice;
  bool _isConnected = false;
  List<String> _receivedData = [];
  bool _isScanning = false;
  
  // Getters
  List<SerialDevice> get availableDevices => _availableDevices;
  SerialDevice? get connectedDevice => _connectedDevice;
  bool get isConnected => _isConnected;
  List<String> get receivedData => _receivedData;
  bool get isScanning => _isScanning;
  
  // 扫描可用串口设备
  Future<void> scanDevices() async {
    try {
      _isScanning = true;
      notifyListeners();
      
      _availableDevices = await _serialService.getAvailableDevices();
      _logger.i('扫描到 ${_availableDevices.length} 个串口设备');
      
    } catch (e) {
      _logger.e('扫描设备失败: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }
  
  // 连接串口设备
  Future<bool> connectDevice(SerialDevice device, SerialConfig config) async {
    try {
      final success = await _serialService.connect(device, config);
      if (success) {
        _connectedDevice = device;
        _isConnected = true;
        _logger.i('成功连接到设备: ${device.name}');
        
        // 开始监听数据
        _serialService.startListening((data) {
          _receivedData.add(data);
          if (_receivedData.length > 100) {
            _receivedData.removeAt(0);
          }
          notifyListeners();
        });
        
        notifyListeners();
        return true;
      }
    } catch (e) {
      _logger.e('连接设备失败: $e');
    }
    return false;
  }
  
  // 断开连接
  Future<void> disconnect() async {
    try {
      await _serialService.disconnect();
      _connectedDevice = null;
      _isConnected = false;
      _receivedData.clear();
      _logger.i('已断开连接');
      notifyListeners();
    } catch (e) {
      _logger.e('断开连接失败: $e');
    }
  }
  
  // 发送指令
  Future<bool> sendCommand(SerialCommand command) async {
    if (!_isConnected) {
      _logger.w('设备未连接');
      return false;
    }
    
    try {
      final success = await _serialService.sendCommand(command);
      if (success) {
        _logger.i('发送指令成功: ${command.command}');
        return true;
      }
    } catch (e) {
      _logger.e('发送指令失败: $e');
    }
    return false;
  }
  
  // 发送电机控制指令
  Future<bool> controlMotor(int motorIndex, bool start) async {
    final command = SerialCommand(
      deviceAddress: 0x00,
      functionCode: 0x05,
      registerAddress: 0x031A + motorIndex,
      data: start ? 0xFF00 : 0x0000,
      description: '${start ? "启动" : "停止"}电机${motorIndex + 1}',
    );
    
    return await sendCommand(command);
  }
  
  // 清空接收数据
  void clearReceivedData() {
    _receivedData.clear();
    notifyListeners();
  }
  
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
} 