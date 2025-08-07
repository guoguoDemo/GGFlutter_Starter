import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  PermissionStatus? _status;

  Future<void> _request() async {
    final status = await Permission.camera.request();
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('权限申请演示')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _request,
              child: const Text('申请相机权限'),
            ),
            const SizedBox(height: 24),
            Text('当前权限状态: ${_status ?? "未知"}'),
          ],
        ),
      ),
    );
  }
}