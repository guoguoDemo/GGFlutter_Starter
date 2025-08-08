import 'package:flutter/material.dart';
import 'package:ggflutter_starter/utils/toast.dart';

class ToastScreen extends StatelessWidget {
  const ToastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toast 演示')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => ToastUtil.show(context, '这是一条 Toast 消息'),
          child: const Text('显示 Toast'),
        ),
      ),
    );
  }
}