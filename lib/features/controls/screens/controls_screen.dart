import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ControlsScreen extends StatelessWidget {
  const ControlsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('🎮 Controls')),
      body: Center(
        child: Text(
          'Controls - Mouse, Keyboard, Gamepad settings',
          style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }
}
