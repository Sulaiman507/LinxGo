import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isLoading = true;
  String _statusMessage = 'Connecting to VNC...';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // Load HTML file from assets
    final htmlString = await rootBundle.loadString('assets/novnc/vnc.html');
    
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1A1A2E))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _statusMessage = 'Error: ${error.description}';
            });
          },
        ),
      )
      ..loadHtmlString(htmlString, baseUrl: 'http://localhost');

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _reload() async {
    if (_controller != null) {
      await _controller.reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasWebView = _controller != null;

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
                  icon: const Icon(Icons.refresh),
                  onPressed: _reload,
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
                  child: Stack(
                    children: [
                      // WebView with noVNC
                      if (hasWebView)
                        WebViewWidget(controller: _controller)
                      else
                        Container(
                          color: const Color(0xFF2D2D2D),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.desktop_windows, size: 64, color: Color(0xFFE94560)),
                                const SizedBox(height: 16),
                                const Text('Linux Desktop', style: TextStyle(color: Colors.white, fontSize: 18)),
                                const SizedBox(height: 8),
                                Text('VNC: localhost:5901', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('WebSocket: localhost:6080', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      // Loading overlay
                      if (_isLoading && hasWebView)
                        Container(
                          color: const Color(0xFF1A1A2E),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Color(0xFFE94560)),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _statusMessage,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
                    _buildToolbarBtn(Icons.mouse, '🖱️', () {}),
                    _buildToolbarBtn(Icons.content_copy, '📋', () {}),
                    _buildToolbarBtn(Icons.refresh, '🔄', _reload),
                    _buildToolbarBtn(Icons.terminal, '💻', () {}),
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
}
