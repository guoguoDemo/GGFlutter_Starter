// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ggflutter_starter/main.dart';

void main() {
  testWidgets('HomeScreen has theme and language buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // 检查主题切换按钮
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
    // 检查语言切换按钮
    expect(find.byIcon(Icons.language), findsOneWidget);
    // 检查多语言文本
    expect(find.text('Flutter App Template').hitTestable(), findsOneWidget);
    // 切换主题
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pump();
    // 切换语言
    await tester.tap(find.byIcon(Icons.language));
    await tester.pump();
  });
}
