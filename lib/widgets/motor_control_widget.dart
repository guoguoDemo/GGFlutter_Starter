import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vending_machine_control/providers/serial_provider.dart';
import 'package:vending_machine_control/models/serial_command.dart';

class MotorControlWidget extends StatefulWidget {
  const MotorControlWidget({super.key});

  @override
  State<MotorControlWidget> createState() => _MotorControlWidgetState();
}

class _MotorControlWidgetState extends State<MotorControlWidget> {
  final TextEditingController _customCommandController = TextEditingController();
  int _selectedMotorIndex = 0;
  bool _isSending = false;

  @override
  void dispose() {
    _customCommandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SerialProvider>(
      builder: (context, provider, child) {
        if (!provider.isConnected) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  '请先连接串口设备',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 电机选择
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '电机选择',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _selectedMotorIndex,
                        decoration: const InputDecoration(
                          labelText: '选择电机',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(60, (index) {
                          return DropdownMenuItem<int>(
                            value: index,
                            child: Text('电机 ${index + 1}'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _selectedMotorIndex = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 电机控制
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '电机控制',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSending ? null : () => _controlMotor(true),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('启动电机'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSending ? null : () => _controlMotor(false),
                              icon: const Icon(Icons.stop),
                              label: const Text('停止电机'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 批量控制
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '批量控制',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSending ? null : () => _batchControl(true),
                              icon: const Icon(Icons.playlist_play),
                              label: const Text('启动所有'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isSending ? null : () => _batchControl(false),
                                                             icon: const Icon(Icons.stop),
                              label: const Text('停止所有'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 自定义指令
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '自定义指令',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _customCommandController,
                        decoration: const InputDecoration(
                          labelText: '输入十六进制指令',
                          hintText: '例如: 00 05 1A 03 FF 00',
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSending ? null : _sendCustomCommand,
                          icon: const Icon(Icons.send),
                          label: const Text('发送指令'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 快速指令
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '快速指令',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // 状态读取
                          _buildQuickCommandButton('读取通道1', '01 04 00 00 00 01 31 CA'),
                          _buildQuickCommandButton('读取通道2', '01 04 00 01 00 01 60 0A'),
                          _buildQuickCommandButton('读取通道3', '01 04 00 02 00 01 91 CA'),
                          _buildQuickCommandButton('读取通道4', '01 04 00 03 00 01 C0 0A'),
                          _buildQuickCommandButton('读取1-4通道', '01 04 00 00 00 04 70 09'),
                          _buildQuickCommandButton('读取1-8通道', '01 04 00 00 00 08 B0 0C'),
                          
                          // 通道控制
                          _buildQuickCommandButton('启动通道1', '01 06 00 00 00 01 48 0A'),
                          _buildQuickCommandButton('停止通道1', '01 06 00 00 00 00 89 CA'),
                          _buildQuickCommandButton('启动通道2', '01 06 00 01 00 01 19 CA'),
                          _buildQuickCommandButton('停止通道2', '01 06 00 01 00 00 58 0A'),
                          _buildQuickCommandButton('启动通道3', '01 06 00 02 00 01 E9 CA'),
                          _buildQuickCommandButton('停止通道3', '01 06 00 02 00 00 A8 0A'),
                          _buildQuickCommandButton('启动通道4', '01 06 00 03 00 01 B8 0A'),
                          _buildQuickCommandButton('停止通道4', '01 06 00 03 00 00 F9 CA'),
                          
                          // 批量控制
                          _buildQuickCommandButton('全部启动', '01 06 00 34 00 01 7A 0A'),
                          _buildQuickCommandButton('全部停止', '01 06 00 34 00 00 3B CA'),
                          _buildQuickCommandButton('控制1-16', '01 06 00 35 00 01 2B CA'),
                          _buildQuickCommandButton('控制17-32', '01 06 00 36 00 01 1A 0A'),
                          _buildQuickCommandButton('控制33-48', '01 06 00 37 00 01 4B CA'),
                          
                          // 参数设置
                          _buildQuickCommandButton('设置地址2', '01 06 00 32 00 02 A9 C4'),
                          _buildQuickCommandButton('设置地址3', '01 06 00 32 00 03 E8 04'),
                          _buildQuickCommandButton('设置38400', '01 06 00 33 00 04 78 06'),
                          _buildQuickCommandButton('设置115200', '01 06 00 33 00 07 39 C6'),
                          _buildQuickCommandButton('断开10秒关', '01 06 00 30 00 64 88 2E'),
                          _buildQuickCommandButton('断开30秒关', '01 06 00 30 00 12 89 6E'),
                          
                          // 工作模式
                          _buildQuickCommandButton('普通模式', '01 06 00 96 00 00 6A 2E'),
                          _buildQuickCommandButton('联动模式', '01 06 00 96 00 01 2B EE'),
                          _buildQuickCommandButton('点动模式', '01 06 00 96 00 02 E8 0E'),
                          _buildQuickCommandButton('开关循环', '01 06 00 96 00 03 A9 CE'),
                          _buildQuickCommandButton('自动复位', '01 06 00 96 00 04 6A 0E'),
                        ],
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

  Widget _buildQuickCommandButton(String label, String command) {
    return ElevatedButton(
      onPressed: _isSending ? null : () => _sendQuickCommand(command),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
      ),
      child: Text(label),
    );
  }

  Future<void> _controlMotor(bool start) async {
    setState(() => _isSending = true);
    
    try {
      final success = await context.read<SerialProvider>().controlMotor(_selectedMotorIndex, start);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '指令发送成功' : '指令发送失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _batchControl(bool start) async {
    setState(() => _isSending = true);
    
    try {
      bool allSuccess = true;
      for (int i = 0; i < 60; i++) {
        final success = await context.read<SerialProvider>().controlMotor(i, start);
        if (!success) allSuccess = false;
        await Future.delayed(const Duration(milliseconds: 50)); // 避免发送过快
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(allSuccess ? '批量控制完成' : '部分指令发送失败'),
            backgroundColor: allSuccess ? Colors.green : Colors.orange,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _sendCustomCommand() async {
    final command = _customCommandController.text.trim();
    if (command.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入指令')),
      );
      return;
    }

    setState(() => _isSending = true);
    
    try {
      final success = await context.read<SerialProvider>().sendCommand(
        SerialCommand.fromHexString(command, description: '自定义指令'),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '指令发送成功' : '指令发送失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('指令格式错误: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Future<void> _sendQuickCommand(String command) async {
    setState(() => _isSending = true);
    
    try {
      final success = await context.read<SerialProvider>().sendCommand(
        SerialCommand.fromHexString(command),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '指令发送成功' : '指令发送失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }
} 