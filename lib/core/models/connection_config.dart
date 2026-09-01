import 'package:flutter/foundation.dart';

/// Connection configuration for VNC server
class ConnectionConfig {
  final String host;
  final int port;
  final int vncPort;
  final String password;
  final int resolutionWidth;
  final int resolutionHeight;
  final int colorDepth;

  const ConnectionConfig({
    this.host = 'localhost',
    this.port = 6080,
    this.vncPort = 5901,
    this.password = '',
    this.resolutionWidth = 1280,
    this.resolutionHeight = 720,
    this.colorDepth = 24,
  });

  ConnectionConfig copyWith({
    String? host,
    int? port,
    int? vncPort,
    String? password,
    int? resolutionWidth,
    int? resolutionHeight,
    int? colorDepth,
  }) {
    return ConnectionConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      vncPort: vncPort ?? this.vncPort,
      password: password ?? this.password,
      resolutionWidth: resolutionWidth ?? this.resolutionWidth,
      resolutionHeight: resolutionHeight ?? this.resolutionHeight,
      colorDepth: colorDepth ?? this.colorDepth,
    );
  }

  Map<String, dynamic> toJson() => {
        'host': host,
        'port': port,
        'vncPort': vncPort,
        'password': password,
        'resolutionWidth': resolutionWidth,
        'resolutionHeight': resolutionHeight,
        'colorDepth': colorDepth,
      };

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) {
    return ConnectionConfig(
      host: json['host'] ?? 'localhost',
      port: json['port'] ?? 6080,
      vncPort: json['vncPort'] ?? 5901,
      password: json['password'] ?? '',
      resolutionWidth: json['resolutionWidth'] ?? 1280,
      resolutionHeight: json['resolutionHeight'] ?? 720,
      colorDepth: json['colorDepth'] ?? 24,
    );
  }

  String get resolution => '${resolutionWidth}x$resolutionHeight';
}

/// System statistics
class SystemStats {
  final double cpuUsage;
  final double ramUsageGB;
  final double ramTotalGB;
  final double diskUsageGB;
  final double diskTotalGB;
  final Duration uptime;
  final List<ProcessInfo> processes;
  final bool isConnected;
  final int latencyMs;

  const SystemStats({
    this.cpuUsage = 0,
    this.ramUsageGB = 0,
    this.ramTotalGB = 0,
    this.diskUsageGB = 0,
    this.diskTotalGB = 0,
    this.uptime = Duration.zero,
    this.processes = const [],
    this.isConnected = false,
    this.latencyMs = 0,
  });

  double get ramPercentage =>
      ramTotalGB > 0 ? (ramUsageGB / ramTotalGB) * 100 : 0;

  double get diskPercentage =>
      diskTotalGB > 0 ? (diskUsageGB / diskTotalGB) * 100 : 0;
}

/// Process information
class ProcessInfo {
  final int pid;
  final String name;
  final double cpuPercent;
  final double memPercent;

  const ProcessInfo({
    required this.pid,
    required this.name,
    required this.cpuPercent,
    required this.memPercent,
  });
}
