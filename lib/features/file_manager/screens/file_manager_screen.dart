import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class FileManagerScreen extends StatelessWidget {
  const FileManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('📁 File Manager')),
      body: Center(
        child: Text(
          'File Manager - Browse Linux & Android files',
          style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }
}
