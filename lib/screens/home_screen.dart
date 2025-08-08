import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ggflutter_starter/providers/theme_provider.dart';
import 'package:ggflutter_starter/l10n/app_localizations.dart';
import 'package:ggflutter_starter/widgets/app_button.dart';
import 'package:ggflutter_starter/widgets/app_text_field.dart';
import 'package:ggflutter_starter/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final local = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.title),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme(themeProvider.themeMode != ThemeMode.dark);
            },
            tooltip: local.theme,
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (locale) => themeProvider.setLocale(locale),
            itemBuilder: (context) => [
                          const PopupMenuItem(
              value: Locale('zh'),
              child: Text('中文'),
            ),
            const PopupMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            ],
            tooltip: local.language,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(local.hello, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 32),
            AppTextField(
              hintText: '请输入内容',
              controller: _controller,
            ),
            const SizedBox(height: 16),
            AppButton(
              text: '显示 Toast',
              onPressed: () {
                ToastUtil.show(context, _controller.text.isEmpty ? '请输入内容' : _controller.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
