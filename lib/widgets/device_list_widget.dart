import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vending_machine_control/providers/serial_provider.dart';
import 'package:vending_machine_control/models/serial_device.dart';
import 'package:vending_machine_control/services/serial_service.dart';

class DeviceListWidget extends StatelessWidget {
  const DeviceListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SerialProvider>(
      builder: (context, provider, child) {
        if (provider.isScanning) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('正在扫描串口设备...'),
              ],
            ),
          );
        }

        if (provider.availableDevices.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.devices_other,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '未找到串口设备',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '请确保设备已正确连接',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => provider.scanDevices(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新扫描'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.availableDevices.length,
          itemBuilder: (context, index) {
            final device = provider.availableDevices[index];
            final isConnected = provider.connectedDevice?.path == device.path;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isConnected ? Colors.green : Colors.blue,
                  child: Icon(
                    Icons.devices,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  device.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.path),
                    if (device.description.isNotEmpty)
                      Text(
                        device.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: isConnected
                    ? const Chip(
                        label: Text('已连接'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () {
                  if (!isConnected) {
                    _showConnectDialog(context, device);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showConnectDialog(BuildContext context, SerialDevice device) {
    showDialog(
      context: context,
      builder: (context) => DeviceConnectDialog(device: device),
    );
  }
}

class DeviceConnectDialog extends StatefulWidget {
  final SerialDevice device;

  const DeviceConnectDialog({
    super.key,
    required this.device,
  });

  @override
  State<DeviceConnectDialog> createState() => _DeviceConnectDialogState();
}

class _DeviceConnectDialogState extends State<DeviceConnectDialog> {
  int _selectedBaudRate = 9600;
  int _selectedDataBits = 8;
  int _selectedStopBits = 1;
  String _selectedParity = '无';
  String _selectedFlowControl = '无';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('连接设备: ${widget.device.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDropdown<int>(
              label: '波特率',
              value: _selectedBaudRate,
              items: SerialService.baudRates,
              onChanged: (value) => setState(() => _selectedBaudRate = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown<int>(
              label: '数据位',
              value: _selectedDataBits,
              items: SerialService.dataBits,
              onChanged: (value) => setState(() => _selectedDataBits = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown<int>(
              label: '停止位',
              value: _selectedStopBits,
              items: SerialService.stopBits,
              onChanged: (value) => setState(() => _selectedStopBits = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: '校验位',
              value: _selectedParity,
              items: SerialService.parityOptions,
              onChanged: (value) => setState(() => _selectedParity = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdown<String>(
              label: '流控制',
              value: _selectedFlowControl,
              items: SerialService.flowControlOptions,
              onChanged: (value) => setState(() => _selectedFlowControl = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () => _connectDevice(context),
          child: const Text('连接'),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label),
        ),
        Expanded(
          child: DropdownButtonFormField<T>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _connectDevice(BuildContext context) async {
    final config = SerialConfig(
      baudRate: _selectedBaudRate,
      dataBits: _selectedDataBits,
      stopBits: _selectedStopBits,
      parity: SerialService.getParityValue(_selectedParity),
      flowControl: SerialService.getFlowControlValue(_selectedFlowControl),
    );

    final success = await context.read<SerialProvider>().connectDevice(widget.device, config);
    
    if (mounted) {
      Navigator.of(context).pop();
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('成功连接到 ${widget.device.name}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('连接失败，请检查设备状态'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
} 