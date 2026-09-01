import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('📊 Statistics')),
      body: Center(
        child: Text(
          'Statistics - System resources and performance',
          style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }
}
