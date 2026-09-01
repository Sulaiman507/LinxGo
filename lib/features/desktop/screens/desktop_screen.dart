import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class DesktopScreen extends StatelessWidget {
  const DesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🖥️ سطح المكتب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.mouse_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Desktop View (noVNC placeholder)
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary).withOpacity(0.2),
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.desktop_windows, size: 64, color: AppColors.lightAccent),
                    SizedBox(height: 16),
                    Text('Linux Desktop View'),
                    SizedBox(height: 8),
                    Text(
                      'VNC Connection: localhost:5901',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : AppColors.lightPrimary).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildToolbarBtn(Icons.keyboard, '⌨️', () {}),
                _buildToolbarBtn(Icons.mouse, '🖱️', () {}),
                _buildToolbarBtn(Icons.content_copy, '📋', () {}),
                _buildToolbarBtn(Icons.zoom_in, '🔍+', () {}),
                _buildToolbarBtn(Icons.zoom_out, '🔍−', () {}),
                _buildToolbarBtn(Icons.folder, '📁', () => context.go('/home/files')),
                _buildToolbarBtn(Icons.terminal, '💻', () => context.go('/home/terminal')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
