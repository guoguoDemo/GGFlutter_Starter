// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ggflutter_starter/main.dart';
import 'package:ggflutter_starter/providers/theme_provider.dart';

void main() {
  testWidgets('HomeScreen has theme and language buttons', (WidgetTester tester) async {
    // 预设语言为英文，避免不同环境下默认语言不一致导致断言失败
    final themeProvider = ThemeProvider();
    themeProvider.setLocale(const Locale('en'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: themeProvider,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 主题按钮（浅色或深色任一）
    final hasLight = find.byIcon(Icons.light_mode).evaluate().isNotEmpty;
    final hasDark = find.byIcon(Icons.dark_mode).evaluate().isNotEmpty;
    expect(hasLight || hasDark, isTrue);

    // 语言按钮存在
    expect(find.byIcon(Icons.language), findsOneWidget);

    // 标题（英文）存在
    expect(find.text('Flutter App Template').hitTestable(), findsOneWidget);

    // 切换主题
    await tester.tap(hasLight ? find.byIcon(Icons.light_mode) : find.byIcon(Icons.dark_mode));
    await tester.pump();

    // 打开语言菜单
    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();

    // 选择中文
    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();
  });
}
