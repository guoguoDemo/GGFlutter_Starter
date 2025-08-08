import 'package:flutter/material.dart';
import 'package:ggflutter_starter/services/http_service.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  String _result = '';
  bool _loading = false;

  Future<void> _fetch() async {
    setState(() { _loading = true; _result = ''; });
    try {
      // 示例接口，可替换为实际 API
      final response = await HttpService.get('https://jsonplaceholder.typicode.com/todos/1');
      setState(() { _result = response.data.toString(); });
    } catch (e) {
      setState(() { _result = '请求失败: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('网络请求演示')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _fetch,
              child: const Text('发起 GET 请求'),
            ),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : SelectableText(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}