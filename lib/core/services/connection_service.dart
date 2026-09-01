import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/connection_config.dart';

/// Service for managing VNC connection settings
class ConnectionService {
  static const String _keyHost = 'connection_host';
  static const String _keyPort = 'connection_port';
  static const String _keyVncPort = 'connection_vnc_port';
  static const String _keyPassword = 'connection_password';
  static const String _keyResWidth = 'connection_res_width';
  static const String _keyResHeight = 'connection_res_height';
  static const String _keyColorDepth = 'connection_color_depth';

  ConnectionConfig _config = const ConnectionConfig();
  ConnectionConfig get config => _config;

  final _controller = StreamController<ConnectionConfig>.broadcast();
  Stream<ConnectionConfig> get stream => _controller.stream;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _config = ConnectionConfig(
      host: prefs.getString(_keyHost) ?? 'localhost',
      port: prefs.getInt(_keyPort) ?? 6080,
      vncPort: prefs.getInt(_keyVncPort) ?? 5901,
      password: prefs.getString(_keyPassword) ?? '',
      resolutionWidth: prefs.getInt(_keyResWidth) ?? 1280,
      resolutionHeight: prefs.getInt(_keyResHeight) ?? 720,
      colorDepth: prefs.getInt(_keyColorDepth) ?? 24,
    );
    _controller.add(_config);
  }

  Future<void> save(ConnectionConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyHost, config.host);
    await prefs.setInt(_keyPort, config.port);
    await prefs.setInt(_keyVncPort, config.vncPort);
    await prefs.setString(_keyPassword, config.password);
    await prefs.setInt(_keyResWidth, config.resolutionWidth);
    await prefs.setInt(_keyResHeight, config.resolutionHeight);
    await prefs.setInt(_keyColorDepth, config.colorDepth);
    _config = config;
    _controller.add(_config);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyHost);
    await prefs.remove(_keyPort);
    await prefs.remove(_keyVncPort);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyResWidth);
    await prefs.remove(_keyResHeight);
    await prefs.remove(_keyColorDepth);
    _config = const ConnectionConfig();
    _controller.add(_config);
  }

  String get vncUrl => 'vnc://${_config.host}:${_config.vncPort}';
  String get wsUrl => 'ws://${_config.host}:${_config.port}';

  void dispose() {
    _controller.close();
  }
}
