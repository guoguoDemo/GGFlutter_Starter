import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vending_machine_control/providers/serial_provider.dart';

class DataMonitorWidget extends StatelessWidget {
  const DataMonitorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SerialProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 数据统计
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.analytics, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            '数据统计',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          if (provider.receivedData.isNotEmpty)
                            TextButton.icon(
                              onPressed: () => provider.clearReceivedData(),
                              icon: const Icon(Icons.clear, size: 16),
                              label: const Text('清空'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              '接收数据',
                              '${provider.receivedData.length}',
                              Icons.download,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              '连接状态',
                              provider.isConnected ? '已连接' : '未连接',
                              provider.isConnected ? Icons.wifi : Icons.wifi_off,
                              provider.isConnected ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 实时数据
              Expanded(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.monitor, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              '实时数据',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            if (provider.isConnected)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: provider.receivedData.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.data_usage,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      '暂无数据',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '连接设备后开始接收数据',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: provider.receivedData.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  final data = provider.receivedData[provider.receivedData.length - 1 - index];
                                  return _buildDataItem(data, index);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(DateTime.now()),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _parseData(data),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  String _parseData(String hexData) {
    try {
      final bytes = hexData.split(' ').map((s) => int.parse(s, radix: 16)).toList();
      
      if (bytes.length < 2) return '数据格式错误';
      
      final deviceAddress = bytes[0];
      final functionCode = bytes[1];
      
      String description = '设备地址: 0x${deviceAddress.toRadixString(16).padLeft(2, '0')}, ';
      
      switch (functionCode) {
        case 0x01:
          description += '功能码: 读线圈状态';
          break;
        case 0x03:
          description += '功能码: 读保持寄存器';
          break;
        case 0x05:
          description += '功能码: 写单个线圈';
          break;
        case 0x06:
          description += '功能码: 写单个寄存器';
          break;
        default:
          description += '功能码: 0x${functionCode.toRadixString(16).padLeft(2, '0')}';
      }
      
      if (bytes.length >= 4) {
        final registerAddress = (bytes[2] << 8) | bytes[3];
        description += ', 寄存器地址: 0x${registerAddress.toRadixString(16).padLeft(4, '0')}';
      }
      
      return description;
    } catch (e) {
      return '数据解析错误';
    }
  }
} 