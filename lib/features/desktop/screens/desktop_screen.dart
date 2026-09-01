import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/vnc_service.dart';
import '../../../core/services/connection_service.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  late VNCService _vncService;
  bool _isFullscreen = false;
  bool _showKeyboard = false;
  double _zoom = 1.0;

  @override
  void initState() {
    super.initState();
    _vncService = VNCService(ConnectionService());
  }

  @override
  void dispose() {
    _vncService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: const Text('🖥️ Desktop'),
              actions: [
                IconButton(
                  icon: Icon(_showKeyboard ? Icons.keyboard_hide : Icons.keyboard),
                  onPressed: () => setState(() => _showKeyboard = !_showKeyboard),
                ),
                IconButton(
                  icon: const Icon(Icons.mouse),
                  onPressed: () => _showMouseOptions(context),
                ),
                IconButton(
                  icon: Icon(_zoom == 1.0 ? Icons.zoom_in : Icons.zoom_out),
                  onPressed: () => setState(() => _zoom = _zoom == 1.0 ? 1.5 : 1.0),
                ),
                IconButton(
                  icon: Icon(_isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: () => setState(() => _isFullscreen = !_isFullscreen),
                ),
              ],
            ),
      body: SafeArea(
        top: !_isFullscreen,
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: _isFullscreen ? EdgeInsets.zero : const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: _isFullscreen ? null : BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: _isFullscreen ? BorderRadius.zero : BorderRadius.circular(12),
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Container(
                      color: const Color(0xFF2D2D2D),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.desktop_windows, size: 64, color: Color(0xFFE94560)),
                            SizedBox(height: 16),
                            Text('Linux Desktop', style: TextStyle(color: Colors.white, fontSize: 18)),
                            SizedBox(height: 8),
                            Text('VNC: localhost:5901', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            SizedBox(height: 4),
                            Text('WebSocket: localhost:6080', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!_isFullscreen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildToolbarBtn(Icons.keyboard, '⌈️', () => setState(() => _showKeyboard = !_showKeyboard)),
                    _buildToolbarBtn(Icons.mouse, '🖱️', () => _showMouseOptions(context)),
                    _buildToolbarBtn(Icons.content_copy, '📋', () {}),
                    _buildToolbarBtn(Icons.zoom_in, '🔍+', () => setState(() => _zoom = (_zoom + 0.25).clamp(0.5, 3.0))),
                    _buildToolbarBtn(Icons.zoom_out, '🔍−', () => setState(() => _zoom = (_zoom - 0.25).clamp(0.5, 3.0))),
                    _buildToolbarBtn(Icons.folder, '📁', () => context.go('/home/files')),
                    _buildToolbarBtn(Icons.terminal, '💻', () => context.go('/home/terminal')),
                  ],
                ),
              ),
            if (_showKeyboard)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildKey('Ctrl'),
                    _buildKey('Alt'),
                    _buildKey('Tab'),
                    _buildKey('Esc'),
                    _buildKey('↑'),
                    _buildKey('↓'),
                    _buildKey('←'),
                    _buildKey('→'),
                  ],
                ),
              ),
          ],
        ),
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

  Widget _buildKey(String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.lightAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showMouseOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Mouse Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.touch_app),
              title: const Text('Direct Touch'),
              subtitle: const Text('Tap to click, long press for right click'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.mouse),
              title: const Text('Touchpad Mode'),
              subtitle: const Text('Move finger to move cursor, tap to click'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
