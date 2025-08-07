import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('主题色切换演示')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('系统默认'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (v) => themeProvider.toggleTheme(v == ThemeMode.dark),
            ),
          ),
          ListTile(
            title: const Text('明亮模式'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (v) => themeProvider.toggleTheme(false),
            ),
          ),
          ListTile(
            title: const Text('暗黑模式'),
            trailing: Radio<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (v) => themeProvider.toggleTheme(true),
            ),
          ),
        ],
      ),
    );
  }
}