import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Settings')),
      body: Center(
        child: Text(
          'Settings - Configure connection, display, controls',
          style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }
}
