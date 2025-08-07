import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_tab_screen.dart';
import '../screens/login_screen.dart';
import '../screens/network_screen.dart';
import '../screens/image_picker_screen.dart';
import '../screens/qr_screen.dart';
import '../screens/permission_screen.dart';
import '../screens/cache_screen.dart';
import '../screens/toast_screen.dart';
import '../screens/dialog_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/theme_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainTabScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: 'network',
          builder: (context, state) => const NetworkScreen(),
        ),
        GoRoute(
          path: 'image',
          builder: (context, state) => const ImagePickerScreen(),
        ),
        GoRoute(
          path: 'qr',
          builder: (context, state) => const QrScreen(),
        ),
        GoRoute(
          path: 'permission',
          builder: (context, state) => const PermissionScreen(),
        ),
        GoRoute(
          path: 'cache',
          builder: (context, state) => const CacheScreen(),
        ),
        GoRoute(
          path: 'toast',
          builder: (context, state) => const ToastScreen(),
        ),
        GoRoute(
          path: 'dialog',
          builder: (context, state) => const DialogScreen(),
        ),
        GoRoute(
          path: 'loading',
          builder: (context, state) => const LoadingScreen(),
        ),
        GoRoute(
          path: 'theme',
          builder: (context, state) => const ThemeScreen(),
        ),
      ],
    ),
  ],
);