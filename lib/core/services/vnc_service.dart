import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../models/connection_config.dart';
import 'connection_service.dart';

/// Service for VNC WebSocket connection
class VNCService {
  final ConnectionService _connectionService;
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String? _errorMessage;

  final _statusController = StreamController<VNCStatus>.broadcast();
  Stream<VNCStatus> get statusStream => _statusController.stream;

  bool get isConnected => _isConnected;
  String? get errorMessage => _errorMessage;

  VNCService(this._connectionService);

  Future<void> connect() async {
    try {
      _statusController.add(VNCStatus.connecting);
      final config = _connectionService.config;
      final wsUrl = 'ws://${config.host}:${config.port}';
      
      _channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {'Origin': 'http://localhost'},
      );

      await _channel!.ready;
      _isConnected = true;
      _errorMessage = null;
      _statusController.add(VNCStatus.connected);

      // Listen for messages
      _channel!.stream.listen(
        (message) {
          // Handle VNC messages
        },
        onError: (error) {
          _isConnected = false;
          _errorMessage = error.toString();
          _statusController.add(VNCStatus.error);
        },
        onDone: () {
          _isConnected = false;
          _statusController.add(VNCStatus.disconnected);
        },
      );
    } catch (e) {
      _isConnected = false;
      _errorMessage = e.toString();
      _statusController.add(VNCStatus.error);
      rethrow;
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _statusController.add(VNCStatus.disconnected);
  }

  void sendData(List<int> data) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(data);
    }
  }

  void dispose() {
    disconnect();
    _statusController.close();
  }
}

enum VNCStatus {
  disconnected,
  connecting,
  connected,
  error,
}
