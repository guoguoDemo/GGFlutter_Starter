import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheScreen extends StatefulWidget {
  const CacheScreen({super.key});

  @override
  State<CacheScreen> createState() => _CacheScreenState();
}

class _CacheScreenState extends State<CacheScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _cached;

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('demo_key', _controller.text);
    setState(() {});
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cached = prefs.getString('demo_key');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('数据缓存演示')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: '要缓存的内容'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _save, child: const Text('保存')),
                const SizedBox(width: 16),
                ElevatedButton(onPressed: _load, child: const Text('读取')),
              ],
            ),
            const SizedBox(height: 24),
            Text('缓存内容: ${_cached ?? "(无)"}'),
          ],
        ),
      ),
    );
  }
}