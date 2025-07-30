import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vending_machine_control/providers/serial_provider.dart';
import 'package:vending_machine_control/screens/home_screen.dart';
import 'package:vending_machine_control/utils/theme.dart';

void main() {
  runApp(const VendingMachineApp());
}

class VendingMachineApp extends StatelessWidget {
  const VendingMachineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SerialProvider()),
      ],
      child: MaterialApp(
        title: '自动售货机控制',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
} 