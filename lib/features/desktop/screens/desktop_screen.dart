import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_colors.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  late final WebViewController _controller;
  bool _isFullscreen = false;
  bool _showKeyboard = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0A1A))
      ..setNavigationDelegate(NavigationDelegate(
        onWebResourceError: (error) {
          debugPrint('WebView error: ${error.description}');
        },
      ))
      // Load noVNC with auto-connect parameters
      ..loadRequest(Uri.parse('http://127.0.0.1:6080/vnc.html?host=127.0.0.1&port=6080&autoconnect=true&password=password'));

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: _isFullscreen ? null : AppBar(
        title: const Text('🖥️ Desktop'),
        actions: [
          IconButton(
            icon: Icon(_showKeyboard ? Icons.keyboard_hide : Icons.keyboard),
            onPressed: () => setState(() => _showKeyboard = !_showKeyboard),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
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
                  child: WebViewWidget(controller: _controller),
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
                    _buildBtn(Icons.keyboard, '⌈️', () => setState(() => _showKeyboard = !_showKeyboard)),
                    _buildBtn(Icons.mouse, '🖱️', () {}),
                    _buildBtn(Icons.refresh, '🔄', () => _controller.reload()),
                    _buildBtn(Icons.terminal, '💻', () {}),
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
                    _buildKey('Ctrl'), _buildKey('Alt'), _buildKey('Tab'), _buildKey('Esc'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 20), const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10)),
      ]),
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
}
