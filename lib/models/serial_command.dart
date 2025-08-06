class SerialCommand {
  final int deviceAddress;
  final int functionCode;
  final int registerAddress;
  final int data;
  final String description;
  final String? customCommand;
  
  SerialCommand({
    required this.deviceAddress,
    required this.functionCode,
    required this.registerAddress,
    required this.data,
    required this.description,
    this.customCommand,
  });
  
  // 获取完整的Modbus指令
  String get command {
    if (customCommand != null) {
      return customCommand!;
    }
    
    // 构建Modbus RTU指令
    final bytes = <int>[];
    
    // 设备地址
    bytes.add(deviceAddress);
    
    // 功能码
    bytes.add(functionCode);
    
    // 寄存器地址（高字节在前）
    bytes.add((registerAddress >> 8) & 0xFF);
    bytes.add(registerAddress & 0xFF);
    
    // 数据（高字节在前）
    bytes.add((data >> 8) & 0xFF);
    bytes.add(data & 0xFF);
    
    // 计算CRC
    final crc = _calculateCRC16(bytes);
    bytes.add(crc & 0xFF);
    bytes.add((crc >> 8) & 0xFF);
    
    // 转换为十六进制字符串
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
  }
  
  // 计算CRC16 Modbus
  int _calculateCRC16(List<int> data) {
    int crc = 0xFFFF;
    
    for (int byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc = (crc >> 1) ^ 0xA001;
        } else {
          crc = crc >> 1;
        }
      }
    }
    
    return crc;
  }
  
  // 从十六进制字符串创建指令
  factory SerialCommand.fromHexString(String hexString, {String? description}) {
    final bytes = hexString
        .replaceAll(' ', '')
        .split('')
        .map((s) => int.parse(s, radix: 16))
        .toList();
    
    if (bytes.length < 6) {
      throw ArgumentError('指令长度不足');
    }
    
    return SerialCommand(
      deviceAddress: bytes[0],
      functionCode: bytes[1],
      registerAddress: (bytes[2] << 8) | bytes[3],
      data: (bytes[4] << 8) | bytes[5],
      description: description ?? '自定义指令',
      customCommand: hexString,
    );
  }
  
  // 创建电机控制指令（汇控电子模块）
  factory SerialCommand.motorControl(int motorIndex, bool start, {int deviceAddress = 0x01}) {
    return SerialCommand(
      deviceAddress: deviceAddress,
      functionCode: 0x06, // 写单个保持寄存器
      registerAddress: motorIndex, // 寄存器地址：0=通道1, 1=通道2, 2=通道3...
      data: start ? 0x0001 : 0x0000, // 1=开启, 0=关闭
      description: '${start ? "启动" : "停止"}通道${motorIndex + 1}',
    );
  }
  
  // 创建批量控制指令
  factory SerialCommand.batchControl(bool start, {int deviceAddress = 0x01}) {
    return SerialCommand(
      deviceAddress: deviceAddress,
      functionCode: 0x06, // 写单个保持寄存器
      registerAddress: 0x34, // 40053寄存器：批量控制
      data: start ? 0x0001 : 0x0000, // 1=全开, 0=全关
      description: start ? '批量启动所有通道' : '批量停止所有通道',
    );
  }
  
  // 创建读取输入状态指令
  factory SerialCommand.readInputStatus(int startChannel, int count, {int deviceAddress = 0x01}) {
    return SerialCommand(
      deviceAddress: deviceAddress,
      functionCode: 0x04, // 读输入寄存器
      registerAddress: startChannel, // 起始通道
      data: count, // 读取数量
      description: '读取通道${startChannel + 1}到${startChannel + count}的输入状态',
    );
  }
  
  // 创建读取状态指令
  factory SerialCommand.readStatus({int deviceAddress = 0x00}) {
    return SerialCommand(
      deviceAddress: deviceAddress,
      functionCode: 0x01, // 读线圈状态
      registerAddress: 0x0000,
      data: 0x0008, // 读取8个线圈
      description: '读取设备状态',
    );
  }
  
  @override
  String toString() {
    return 'SerialCommand(deviceAddress: 0x${deviceAddress.toRadixString(16)}, functionCode: 0x${functionCode.toRadixString(16)}, registerAddress: 0x${registerAddress.toRadixString(16)}, data: 0x${data.toRadixString(16)}, description: $description)';
  }
} 