import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.login, 'label': '登录页', 'route': '/login'},
      {'icon': Icons.http, 'label': '网络请求', 'route': '/network'},
      {'icon': Icons.image, 'label': '图片选择', 'route': '/image'},
      {'icon': Icons.qr_code, 'label': '二维码', 'route': '/qr'},
      {'icon': Icons.security, 'label': '权限申请', 'route': '/permission'},
      {'icon': Icons.save, 'label': '数据缓存', 'route': '/cache'},
      {'icon': Icons.message, 'label': 'Toast', 'route': '/toast'},
      {'icon': Icons.chat_bubble, 'label': 'Dialog', 'route': '/dialog'},
      {'icon': Icons.hourglass_empty, 'label': 'Loading', 'route': '/loading'},
      {'icon': Icons.color_lens, 'label': '主题色切换', 'route': '/theme'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('功能')), 
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final f = features[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (f['route'] != null) {
                  context.go(f['route'] as String);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('点击了${f['label']}（待实现）')),
                  );
                }
              },
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(f['icon'] as IconData, size: 40),
                    const SizedBox(height: 12),
                    Text(f['label'] as String, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}