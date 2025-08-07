import 'package:flutter/material.dart';

/// ThemeProvider
///
/// 主题和语言状态管理。
/// 可扩展为持久化存储、跟随系统等。
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('zh');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  /// 切换主题
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// 设置语言
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}