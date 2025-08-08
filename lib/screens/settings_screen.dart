import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggflutter_starter/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('设置')), 
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('暗黑模式'),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (v) => themeProvider.toggleTheme(v),
          ),
          ListTile(
            title: const Text('语言'),
            trailing: DropdownButton<Locale>(
              value: themeProvider.locale,
              items: const [
                DropdownMenuItem(value: Locale('zh'), child: Text('中文')),
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
              ],
              onChanged: (locale) => themeProvider.setLocale(locale!),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('关于'),
            subtitle: Text('Flutter 通用脚手架模板\n版本 1.0.0'),
          ),
        ],
      ),
    );
  }
}