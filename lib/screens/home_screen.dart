import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vending_machine_control/providers/serial_provider.dart';
import 'package:vending_machine_control/widgets/device_list_widget.dart';
import 'package:vending_machine_control/widgets/connection_widget.dart';
import 'package:vending_machine_control/widgets/motor_control_widget.dart';
import 'package:vending_machine_control/widgets/data_monitor_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    
    // 初始化时扫描设备
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SerialProvider>().scanDevices();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自动售货机控制'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.devices), text: '设备'),
            Tab(icon: Icon(Icons.link), text: '连接'),
            Tab(icon: Icon(Icons.settings), text: '控制'),
            Tab(icon: Icon(Icons.monitor), text: '监控'),
          ],
        ),
        actions: [
          Consumer<SerialProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  provider.isConnected ? Icons.wifi : Icons.wifi_off,
                  color: provider.isConnected ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  if (provider.isConnected) {
                    _showDisconnectDialog();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DeviceListWidget(),
          ConnectionWidget(),
          MotorControlWidget(),
          DataMonitorWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<SerialProvider>().scanDevices();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('正在扫描设备...')),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
  
  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('断开连接'),
        content: const Text('确定要断开当前串口连接吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<SerialProvider>().disconnect();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已断开连接')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 