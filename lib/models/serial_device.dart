class SerialDevice {
  final String name;
  final String path;
  final String description;
  final bool isAvailable;
  
  SerialDevice({
    required this.name,
    required this.path,
    required this.description,
    this.isAvailable = true,
  });
  
  factory SerialDevice.fromJson(Map<String, dynamic> json) {
    return SerialDevice(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      description: json['description'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'description': description,
      'isAvailable': isAvailable,
    };
  }
  
  @override
  String toString() {
    return 'SerialDevice(name: $name, path: $path, description: $description)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SerialDevice && other.path == path;
  }
  
  @override
  int get hashCode => path.hashCode;
}

class SerialConfig {
  final int baudRate;
  final int dataBits;
  final int stopBits;
  final int parity;
  final int flowControl;
  
  SerialConfig({
    this.baudRate = 9600,
    this.dataBits = 8,
    this.stopBits = 1,
    this.parity = 0, // 0: None, 1: Odd, 2: Even
    this.flowControl = 0, // 0: None, 1: Hardware, 2: Software
  });
  
  factory SerialConfig.fromJson(Map<String, dynamic> json) {
    return SerialConfig(
      baudRate: json['baudRate'] ?? 9600,
      dataBits: json['dataBits'] ?? 8,
      stopBits: json['stopBits'] ?? 1,
      parity: json['parity'] ?? 0,
      flowControl: json['flowControl'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'baudRate': baudRate,
      'dataBits': dataBits,
      'stopBits': stopBits,
      'parity': parity,
      'flowControl': flowControl,
    };
  }
  
  @override
  String toString() {
    return 'SerialConfig(baudRate: $baudRate, dataBits: $dataBits, stopBits: $stopBits, parity: $parity)';
  }
} 