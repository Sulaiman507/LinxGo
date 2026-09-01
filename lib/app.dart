import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/splash/screens/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/desktop/screens/desktop_screen.dart';
import 'features/terminal/screens/terminal_screen.dart';
import 'features/file_manager/screens/file_manager_screen.dart';
import 'features/controls/screens/controls_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';

/// Centralized app routes using go_router
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'desktop',
          name: 'desktop',
          builder: (context, state) => const DesktopScreen(),
        ),
        GoRoute(
          path: 'terminal',
          name: 'terminal',
          builder: (context, state) => const TerminalScreen(),
        ),
        GoRoute(
          path: 'files',
          name: 'files',
          builder: (context, state) => const FileManagerScreen(),
        ),
        GoRoute(
          path: 'controls',
          name: 'controls',
          builder: (context, state) => const ControlsScreen(),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'statistics',
          name: 'statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
      ],
    ),
  ],
);
